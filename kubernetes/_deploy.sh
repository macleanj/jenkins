#!/bin/bash

now=$(date +%Y-%m-%d\ %H:%M:%S)
programName=$(basename $0)
programDir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
baseName=$(echo ${programName} | sed -e 's/.sh//g')
KUBECONFIG="$HOME/.kube/vagrant-lab-admin.conf"

currentNamepace=$(kubectl config view --minify --output 'jsonpath={..namespace}')
cd $programDir

Usage()
{
  echo ""
  echo "Usage: $programName apply|delete"
  echo ""
  exit 5
}

doApply(){
  echo ">>> Setting up Cluster for Jenkins"
  kubectl apply -k .
}

doDelete(){
  echo ">>> Deleting Jenkins from cluster"

  kubectl config set-context --current --namespace=jenkins
  kubectl delete -k . --namespace=jenkins
}

case "$1" in
  apply)
    doApply
    ./_createCertificates.sh

    # Generate jenkins context
    export KUBECONFIG=$KUBECONFIG
    kubectx kubernetes-admin@kubernetes
    k8-updateKubeConfig.sh -sa jenkins-admin
    k8-updateKubeConfig.sh -sa jenkins
  ;;
  delete) 
    doDelete
    # Delete jenkins context
    export KUBECONFIG=$KUBECONFIG
    kubectx kubernetes-admin@kubernetes
    kubectl config unset users.jenkins-admin
    kubectl config unset contexts.jenkins-admin@kubernetes
    kubectl config unset users.jenkins
    kubectl config unset contexts.jenkins@kubernetes
  ;;
  *)
    Usage
    exit 1
  ;;
esac

kubectl config set-context --current --namespace=$currentNamepace
