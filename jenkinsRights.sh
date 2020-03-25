# The below commands have to be executed every time the docker daemon (re)starts

arch=$(uname -s)
if [ "$arch" == "Darwin" ]; then
  echo "You are on your MAC"
  echo "File System: No changes needed"

  echo "Docker Daemon: granting rights to jenkins user on guest"
  docker exec -ti -u root jenkins_worker-swarm-dind_1 /bin/sh -c 'chmod 666 /var/run/docker.sock'
else
  # grant container user rights (jenkins = UID:GID 1000:1000)
  echo "File System: Changing rights on filesystem to be accessible for jenkins user"
  sudo chown -R 1000:1000 jenkins-master

  # grant rights to "host" docker
  echo "Docker Daemon: granting rights to jenkins user on host"
  sudo chown -R 1000:1000 /var/run/docker.sock
fi
