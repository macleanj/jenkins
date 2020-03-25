pipeline {
    agent any
    stages {
        stage("Hello") {
            steps {
                echo 'Hello World'
                sh "echo SUCCESS"
            }
        }
    }

post {
    always {
      script {
        if (env.BRANCH_NAME == 'master') {
          echo 'This will always run for master'
        } else {
          echo 'This will always run for others'
        }
      }
    }
    success {
      echo 'This will run only if successful'
            emailext (
        subject: "JOB ${env.JOB_NAME} - BUILD #${env.BUILD_NUMBER}: ${currentBuild.currentResult}",
        body: """
<p>JOB ${env.JOB_NAME} - BUILD #${env.BUILD_NUMBER}: ${currentBuild.currentResult}</p>
<p>Check console output at $BUILD_URL to view the results.</p>
""",
        to: "nms.maclean@gmx.com"
      )

      // Send notifications
      slackSend (color: '#FF0000', message: 'Testing')
    }
    failure {
      echo 'This will run only if failed'
    }
    unstable {
      echo 'This will run only if the run was marked as unstable'
    }
    changed {
      echo 'This will run only if the state of the Pipeline has changed'
      echo 'For example, if the Pipeline was previously failing but is now successful'
    }
  // post
  }
}
