pipeline {
    environment {
        registry = "taha3azab/capstone-app"
        registryCredential = 'dockerhubcredentials'
    }
    agent any
    stages {
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
        stage('Building Image') {
            steps{
                script {
                    docker.build registry + ":$BUILD_NUMBER"
                }
            }
        }
        stage('Deploy Image') {
            steps{
                script {
                    docker.withRegistry('', registryCredential) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Scan Dockerfile to find vulnerabilities') {
            steps {
                aquaMicroscanner(imageName: registry +':$BUILD_NUMBER', notCompliesCmd: 'exit 4', onDisallowed: 'fail', outputFormat: 'html')
            }
        }
        stage('Build Docker Container') {
            steps {
                sh 'docker run --name capstone -d -p 80:80 $registry:$BUILD_NUMBER'
            }
        }        
        stage('Remove Unused docker image') {
            steps{
                sh "docker rmi $registry:$BUILD_NUMBER"
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