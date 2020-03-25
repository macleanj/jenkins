pipeline {
  agent {
    kubernetes {
      label 'jenkins-slave'
      cloud 'kubernetes'
      defaultContainer 'dind'
      instanceCap 1
      yaml"""
apiVersion: v1
kind: Pod
metadata:
  labels:
    jenkins/kube-default: true
    app: jenkins
    component: agent
spec:
  serviceAccountName: jenkins
  containers:
    - name: jnlp
      image: jenkinsci/jnlp-slave:3.40-1
      resources:
        limits:
          cpu: 1
          memory: 2Gi
        requests:
          cpu: 0.5
          memory: 1Gi
      env:
      - name: POD_IP
        valueFrom:
          fieldRef:
            fieldPath: status.podIP
      - name: DOCKER_HOST
        value: tcp://localhost:2375
    - name: dind
      image: docker:18.05-dind
      securityContext:
        privileged: true
      volumeMounts:
        - name: dind-storage
          mountPath: /var/lib/docker
  volumes:
    - name: dind-storage
      emptyDir: {}
"""
    }
  }
  stages {
    stage ('Dummy') {
      steps {
        sh 'echo "Hello DinD"'
      }
    }
  }
}