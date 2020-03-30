# User management
In this section the certificate for jenkins can be generated if it no longer works. Just delete the certificates (jenkins.pfx) and run ```./_createCertificate.sh```. Copy the following items into Jenkins:

Credentials:
- Add Secret Text: "Kubernetes TOKEN (jenkins)" (output of script)

Configurations - Kubernetes:
- Name: kubernetes
- URL: https://kubernetes.lab.crosslogic-consulting.com:6443
- Kubernetes server certificate key: "Kubernetes server certificate key" (output of script)
- Kubernetes Namespace: jenkins
- Disable https certificate check
- Credentials: See above
- Jenkins URL: http://10.0.2.2:8082 (this is the VirtualBox Service IP. From within POD: traceroute 8.8.8.8 from vagrant/kubernetes).
- Jenkins tunnel: NA (when Jenkins is behind reversed-proxy or load balancer)
- Pod Labels
  - app: jenkins
  - component: agent

# Demo
- Start cluster (vagrant)
- Explain the environment
- Start Jenkins
- Explain the environment
- Run kubernetes-hello-world
- Watch the Pods spin up
- Explain resilience and differences with EC2

Notes
- Dedicated Pod (on demand) that only has to be started (like the EC2 solution). In that case the data can be used as cache in case needed. Perhaps giving a switch in the pipeline to decide (e.g. after 1d/1w it should delete the pod in total)