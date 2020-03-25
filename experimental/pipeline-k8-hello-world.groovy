pipeline {
  agent {
    kubernetes {
      defaultContainer 'jnlp'
      yaml """
apiVersion: v1
kind: Pod
metadata:
  labels:
    platform: node
spec:
  containers:
  - name: maven
    image: maven:alpine
    command:
    - cat
    tty: true
  - name: node
    image: node:9-alpine
    command:
    - cat
    tty: true
"""
    }
  }
  stages {
    stage('Run local/default') {
      steps {
        // From default 'jnlp' container
        sh 'hostname'
      }
    }
    stage('Run maven') {
      steps {
        container('maven') {
          sh 'mvn -version'
        }
      }
    }
    stage('Run node') {
      steps {
        container('node') {
          sh 'node --version'
        }
      }
    }
  }
}