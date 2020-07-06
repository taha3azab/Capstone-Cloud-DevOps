pipeline {
    environment {
        registry = "taha3azab/capstone-app"
        registryCredential = 'dockerhubcredentials'
        awsCredentials = 'awscredentials'
        awsRegion = 'us-east-1'
    }
    agent any
    stages {
        stage('Hashing images') {
            steps {
                script {
                    env.GIT_HASH = sh(
                        script: "git show --oneline | head -1 | cut -d' ' -f1",
                        returnStdout: true
                    ).trim()
                }
            }
        }
        stage('Lint Dockerfile') {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            post {
                always {
                    archiveArtifacts 'hadolint_lint.txt'
                }
            }
            steps {
                sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
            }
        }
        stage('Build & Push to dockerhub') {
            steps {
                script {
                    dockerImage = docker.build(registry + ":${env.GIT_HASH}")
                    dockerImageLatest = docker.build(registry + ":latest")
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                        dockerImageLatest.push()
                    }
                }
            }
        }
        stage('Run Docker Container') {
            steps {
                sh "docker run --name capstone -d -p 80:80 $registry:${env.GIT_HASH}"
            }
        }        
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:${env.GIT_HASH}"
            }
        }
        stage('Cleaning Docker') {
            steps {
                script {
                    sh "echo 'Cleaning Docker'"
                    sh "docker stop capstone"
                    sh "docker system prune -f"
                }
            }
        }
        stage('Deploy to EKS') {
            steps {
                dir('kubernetes') {
                    withAWS(credentials: ${awsCredentials}, region: ${awsRegion}) {
                            sh "aws eks --region $awsRegion update-kubeconfig --name UdacityCapstoneProject-EKS-Cluster"
                            sh "kubectl get all"
                            sh "kubectl apply -f deployment.yml"
                            sh "kubectl apply -f service.yml"
                            sh "kubectl apply -f load-balancer.yml"
                        }
                    }
            }
        }
    }
}