pipeline {
  environment {
    registry = "kaktas35/sample-web-application"
    registryCredential = '2c76a6d9-b084-4e17-aa26-38e223083859' //dockerhub credentials ID, defined on Jenkins
    imagename = "web-app"
    dockerImage = ''
  }
  agent any
  stages {
    stage('Clone Project from Git') {
      steps {
        git 'https://github.com/kaktas35tr/sample-web-application.git'
      }
    }
    stage('Build Docker Image') {
      steps{
        script {
          dockerImage = docker.build imagename + ":v.$BUILD_NUMBER"
        }
      }
    }
    stage('Push Image to DockerHub') {
      steps{
        script {
          docker.withRegistry( '', registryCredential ) {
            dockerImage.push()
          }
        }
      }
    }
  }
}