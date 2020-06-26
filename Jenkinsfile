pipeline {
    environment {
        registry = "taha3azab/capstone-app"
        registryCredential = 'dockerhubcredentials'
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
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Scan Dockerfile to find vulnerabilities') {
            steps {
                aquaMicroscanner(imageName: registry +':'+ env.GIT_HASH, notCompliesCmd: 'exit 4', onDisallowed: 'fail', outputFormat: 'html')
            }
        }
        stage('Build Docker Container') {
            steps {
                sh 'docker run --name capstone -d -p 80:80 $registry:${env.GIT_HASH}'
            }
        }        
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:${env.GIT_HASH}"
            }
        }
        stage("Cleaning Docker up") {
            steps {
                script {
                    sh "echo 'Cleaning Docker up'"
                    sh "docker system prune"
                }
            }
        }
  }
}