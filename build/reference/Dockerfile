FROM jenkins/jenkins:lts

LABEL Description="DooD to be able to build docker images with Jenkins on Docker"
LABEL MAINTAINER="Jerome Mac Lean"

USER root

# set base environment variables
ARG LOCALE=en_US.UTF-8
ENV TERM=xterm LANGUAGE=${LOCALE} LANG=${LOCALE} LC_ALL=${LOCALE} DEBIAN_FRONTEND=noninteractive

#
# add repos and update
#
RUN apt-get -o Acquire::ForceIPv4=true update && \
apt-get upgrade -f -y && \
#
# Set the locale and timezone (Debian version)
#
apt-get install -y tzdata locales && \
sed -i "s/^# *\(${LOCALE}\)/\1/" /etc/locale.gen && \
locale-gen && \
ln -fs /usr/share/zoneinfo/Europe/Amsterdam /etc/localtime && \
dpkg-reconfigure --frontend noninteractive tzdata

RUN apt-get install -f -y \
apt-transport-https \
ca-certificates \
less \
vim \
curl \
gnupg2 \
software-properties-common && \
curl -fsSL https://download.docker.com/linux/$(. /etc/os-release; echo "$ID")/gpg > /tmp/dkey; apt-key add /tmp/dkey && \
add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/$(. /etc/os-release; echo "$ID") \
   $(lsb_release -cs) \
   stable" && \
apt-get update && \
apt-get -y install docker-ce

# change docker sock permissions after mount
RUN usermod -a -G docker jenkins

#
# clean up
#
RUN \
apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
echo "Done: cleanup"

USER jenkins
