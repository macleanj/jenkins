pipeline {
    agent {
        docker {
            image 'node:9-alpine'
            label 'docker'
            // registryUrl 'https://myregistry.com/'
            // registryCredentialsId 'myPredefinedCredentialsInJenkins'
        }
    }
    stages {
        stage('Test'){
            steps {
                echo 'Hello world'
                // sh 'docker container ls -a'
                sh 'node --version'
            }
        }
    }
}