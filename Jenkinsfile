pipeline {
    environment {
        registry = "taha3azab/capstone-app"
        registryCredential = 'docker-hub-credentials'
    }
    agent any
    stages {
        // stage('Hashing Image') {
        //     steps {
        //         script {
        //             env.GIT_HASH = sh(
        //                 script: "git show --oneline | head -1 | cut -d' ' -f1",
        //                 returnStdout: true
        //             ).trim()
        //         }
        //     }
        // }
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
                sh 'docker run --name capstone -d -p 80:80 taha3azab/capstone-app:$BUILD_NUMBER'
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