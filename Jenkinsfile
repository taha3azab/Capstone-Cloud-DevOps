pipeline {
    environment {
        registry = "taha3azab/capstone-app"
        registryCredential = 'dockerhubcredentials'
        awsCredential = 'aws-static'
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
        stage('Lint HTML') {
            steps{
                dir('app/capstone-app') {
                    sh "tidy -q -e *.html"
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
        stage('Scan Dockerfile to find vulnerabilities') {
            steps {
                aquaMicroscanner(imageName: registry + ":" + env.GIT_HASH, notCompliesCmd: "exit 4", onDisallowed: "fail", outputFormat: "html")
            }
        }
        stage('Run Docker Container') {
            steps {
                sh 'docker run --name capstone -d -p 80:80 $registry:${env.GIT_HASH}'
            }
        }        
        stage('Remove Unused docker image') {
            steps{
                sh 'docker rmi $registry:${env.GIT_HASH}'
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
                    withAWS(credentials: awsCredential, region: awsRegion) {
                            sh 'aws eks --region $awsRegion update-kubeconfig --name UdacityCapstoneProject-EKS-Cluster'
                            sh 'kubectl apply -f deployment.yml'
                            sh 'kubectl apply -f service.yml'
                            sh 'kubectl apply -f load-balancer.yml'
                        }
                    }
            }
        }
    }
}