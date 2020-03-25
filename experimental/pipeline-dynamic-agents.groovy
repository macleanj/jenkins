/*
 * This is a test pipeline that can be (copied and) used to a Jenkins pipeline project as PoC.
 **/

// This library with the branch to test
tgr = library identifier: 'tested-git-repo@develop', retriever: modernSCM (
  [ $class: 'GitSCMSource',
    remote: 'https://github.com/macleanj/jenkins-library.git',
    credentialsId: 'futurice-maclean-github'
  ]
)

jsl = library identifier: 'k8sagent@develop', retriever: modernSCM (
  [ $class: 'GitSCMSource',
    remote: 'https://github.com/macleanj/jenkins-k8sagent-lib.git',
    credentialsId: 'futurice-maclean-github'
  ]
)

// Environment instantiation
def cicd = [build: [:], git: [:], jenkins: [:], config: [:], env: [:]]
cicd.build.debug = 0
cicd.build.throttle = 100
cicd.config.appName = "dynamic-agent"
cicd.config.appLabel = cicd.config.appName.toLowerCase().replaceAll("[_]", "-")
// cicd.build.agents = ""

// The following variable are available start of the pipeline (before node {} and pipeline {})
// This is both true for a pipeline script with a bare pipeline and a Jenkinsfile checked out from GIT in the beginning.
// current dir = /
if (cicd.build.debug == 1) { println "DEBUG: Bare Environment\n" + "env".execute().text }
/*
JENKINS_SLAVE_AGENT_PORT=50000
LANG=C.UTF-8
HOSTNAME=jenkins-master
JENKINS_UC=https://updates.jenkins.io
JAVA_OPTS=-Xmx2048m
JAVA_HOME=/usr/local/openjdk-8
JAVA_VERSION=8u242
PWD=/
HOME=/var/jenkins_home
COPY_REFERENCE_FILE_LOG=/var/jenkins_home/copy_reference_file.log
JENKINS_HOME=/var/jenkins_home
REF=/usr/share/jenkins/ref
JAVA_BASE_URL=https://github.com/AdoptOpenJDK/openjdk8-upstream-binaries/releases/download/jdk8u242-b08/OpenJDK8U-jdk_
JENKINS_INCREMENTALS_REPO_MIRROR=https://repo.jenkins-ci.org/incrementals
SHLVL=0
JAVA_URL_VERSION=8u242b08
JENKINS_UC_EXPERIMENTAL=https://updates.jenkins.io/experimental
PATH=/usr/local/openjdk-8/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
JENKINS_VERSION=2.219
*/

// Enables to collect all GIT and Jenkins variables
// current dir = /
node ('master') {
  stage('Set environment') {
    sh 'echo "master - Stage: Set environment"'
    if (cicd.build.debug == 1) { echo "DEBUG: CICD Environment\n" + sh(script: "printenv | sort", returnStdout: true) }
    cicd.build.agents = (BUILD_NUMBER.toInteger() <= cicd.build.throttle) ? [name: 'base+jenkins_builder+s_micro', cloud: 'kubernetes', label:'jnlp-' + cicd.config.appLabel + '-agent'] : [name: 'base', cloud: 'kubernetes', label:'jnlp-' + cicd.config.appLabel + '-agent-base-only']
  }
}

def myX = '3'

pipeline {
  options {
    // skipDefaultCheckout()
    disableConcurrentBuilds()
    buildDiscarder(
      logRotator(
        artifactDaysToKeepStr: '', 
        artifactNumToKeepStr: myX, 
        daysToKeepStr: '', 
        numToKeepStr: myX
      )
    )
    timestamps()
  }

  // ****************************************************
  // ********************** Agents **********************
  // Parametized agent - NOT WORKING!!
  agent { kubernetes(k8sagent(cicd.build.agents)) }

  // None. Set per stage?
  // agent none

  // Any
  // agent any

  // Fixed lable
  // agent {
  //   label 'docker'
  // }

  // Kubernetes fixed podTemplate
  // agent {
  //   kubernetes {
  //     label 'jnlp'
  //     cloud 'kubernetes'
  //     // defaultContainer 'jenkins-builder'
  //     // instanceCap 1
  //     // yamlFile "build/k8/build-pod-img.yml"
  //     yamlFile "build/k8/build-pod-img.yml"
  //   }
  // }

  // Kubernetes merged podTemplate via library
  // agent {
  //   // Mind the _ (underscore) in the definition. Containers themselves will have the _ exchanged for a -
  //   kubernetes(k8sagent(name: 'base+jenkins_builder+s_micro', label: 'jnlp', cloud: 'kubernetes'))
  // }
  // ********************** Agents **********************
  // ****************************************************
  stages {
    stage ('Set environment') {
      // agent { kubernetes(k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes')) }
      when {
        beforeAgent true
        expression { BUILD_NUMBER.toInteger() <= cicd.build.throttle }
      }
      steps {
        sh "echo HERE > /tmp/tessie"
      }
    }
    stage ('Set environment 2') {
      // agent { kubernetes(k8sagent(name: 'base+s_micro', label: 'jnlp', cloud: 'kubernetes')) }
      when {
        beforeAgent true
        expression { BUILD_NUMBER.toInteger() <= cicd.build.throttle }
      }
      steps {
        sh "cat /tmp/tessie"
      }
    }
  }
}
