pipeline {
    environment {
        dockerhubCredentials = 'docker-hub-credentials'
    }
    agent any
    stages {
        // stage('Lint Dockerfile') {
        //     steps {
        //         script {
        //             docker.image('hadolint/hadolint:latest-debian').inside() {
        //                     sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
        //                     sh '''
        //                         lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
        //                         if [ "$lintErrors" -gt "0" ]; then
        //                             echo "Errors have been found, please see below"
        //                             cat hadolint_lint.txt
        //                             exit 1
        //                         else
        //                             echo "There are no erros found on Dockerfile!!"
        //                         fi
        //                     '''
        //             }
        //         }
        //     }
        // }                   
        // https://github.com/hadolint/hadolint/blob/master/docs/INTEGRATION.md#jenkins-declarative-pipeline
        stage ("lint Dockerfile") {
            agent {
                docker {
                    image 'hadolint/hadolint:latest-debian'
                }
            }
            steps {
                sh 'hadolint ./Dockerfile | tee -a hadolint_lint.txt'
            }
            post {
                always {
                    archiveArtifacts 'hadolint_lint.txt'
                }
            }
        }
        stage('Build & Push to dockerhub') {
            steps {
                script {
                    dockerImage = docker.build("taha3azab/capstone-app")
                    docker.withRegistry('', dockerhubCredentials) {
                        dockerImage.push()
                    }
                }
            }
        }
        stage('Scan Dockerfile to find vulnerabilities') {
            steps{
                aquaMicroscanner imageName: "taha3azab/capstone-app", notCompliesCmd: 'exit 4', onDisallowed: 'fail', outputFormat: 'html'
            }
        }
        stage('Build Docker Container') {
      		steps {
			    sh 'docker run --name capstone -d -p 80:80 taha3azab/capstone-app'
            }
        }
        // stage('Deploying to EKS') {
        //     steps {
        //         dir('k8s') {
        //             withAWS(credentials: 'aws-credentials', region: 'us-east-1') {
        //                     sh "aws eks --region eu-west-1 update-kubeconfig --name capstone"
        //                     sh 'kubectl apply -f capstone-k8s.yaml'
        //                 }
        //             }
        //     }
        // }
        // stage("Cleaning Docker up") {
        //     steps {
        //         script {
        //             sh "echo 'Cleaning Docker up'"
        //             sh "docker system prune"
        //         }
        //     }
        // }
    }
}