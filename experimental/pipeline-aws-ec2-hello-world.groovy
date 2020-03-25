pipeline {
    agent {
        docker {
            image 'node:9-alpine'
            label 'aws-ec2'
            // registryUrl 'https://myregistry.com/'
            // registryCredentialsId 'myPredefinedCredentialsInJenkins'
        }
    }
    stages {
        stage('Test'){
            steps {
                echo 'Hello world. Going to sleep for 600 seconds'
                sh 'sleep 600'
                sh 'node --version'
            }
        }
    }
}