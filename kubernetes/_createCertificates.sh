#!/bin/bash

programDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
cd $programDir

kubectl config set-context --current --namespace=jenkins

echo    ""
echo ">>> Getting information for Jenkins configuration"
# Fetching the server and creating client/user certificate
if [ ! -f ssl/jenkins.pfx ]; then
  echo ">>>>>>>>>>>>>>> Use export key password: \"admin\" <<<<<<<<<<<<<<<"

  # Client
  openssl req -batch -x509 -nodes -days 358000 -newkey rsa:2048 -keyout ssl/jenkins.key -out ssl/jenkins.crt -config ssl/jenkins.conf

  # Kubernetes API
  grep certificate-authority-data ~/.kube/vagrant-lab-admin.conf | sed -e 's/.*certificate-authority-data:[ ]*//g'  | base64 --decode > ssl/kubernetes.crt  

  # Generate Kubetes API client/user certificate
  openssl pkcs12 -export -out ssl/jenkins.pfx -inkey ssl/jenkins.key -in ssl/jenkins.crt -certfile ssl/kubernetes.crt
fi

export APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d ":" | tr -d " ")
export APISERVER_KEY=$(cat ssl/kubernetes.crt)
export SECRET_NAME_JENKINS_ADMIN=$(kubectl get secrets | grep ^jenkins-admin-token | cut -f1 -d ' ')
export TOKEN_JENKINS_ADMIN=$(kubectl describe secret $SECRET_NAME_JENKINS_ADMIN | grep -E '^token' | cut -f2 -d':' | tr -d " ")
export SECRET_NAME_JENKINS=$(kubectl get secrets | grep ^jenkins-token | cut -f1 -d ' ')
export TOKEN_JENKINS=$(kubectl describe secret $SECRET_NAME_JENKINS | grep -E '^token' | cut -f2 -d':' | tr -d " ")

echo    "Kubernetes URL                           : $APISERVER"
echo -e "Kubernetes server certificate key        : \n$APISERVER_KEY"
echo -e "Kubernetes jenkins-admin                 : \n$TOKEN_JENKINS_ADMIN"
echo -e "Kubernetes jenkins                       : \n$TOKEN_JENKINS"
