pipeline {
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
        sh '''lintErrors=$(stat --printf="%s"  hadolint_lint.txt)
if [ "$lintErrors" -gt "0" ]; then
   echo "Errors have been found, please see below"
   cat hadolint_lint.txt
   exit 1
else
   echo "There are no erros found on Dockerfile!!"
fi
                '''
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
      steps {
        aquaMicroscanner(imageName: 'taha3azab/capstone-app', notCompliesCmd: 'exit 4', onDisallowed: 'fail', outputFormat: 'html')
      }
    }

    stage('Build Docker Container') {
      steps {
        sh 'docker run --name capstone -d -p 80:80 taha3azab/capstone-app'
      }
    }

  }
  environment {
    dockerhubCredentials = 'docker-hub-credentials'
  }
}