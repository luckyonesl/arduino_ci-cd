#!/bin/bash
set -e
WKDIR=$(cd "$(dirname "$0")"; pwd -P)
COMPOSE_ENV_FILE=${WKDIR}/docker/jenkins_environment

#prepare ssh keys for usage inside jenkins
echo SSH_JENKINS_PASSWORD='' > ${COMPOSE_ENV_FILE}

#create the arduino docker builder
if [ ! -f docker/secrets/id_rsajenkins ];then
	#generating key
	ssh-keygen -N "${SSH_JENKINS_PASSWORD}" -f docker/secrets/id_rsajenkins
fi
export SSH_JENKINS_KEY=`cat docker/secrets/id_rsajenkins`

export JENKINS_ADMIN_ID=jadmin
if [ ! -f docker/secrets/JENKINS_ADMIN_PASSWORD ];then
   openssl rand -base64 14 > docker/secrets/JENKINS_ADMIN_PASSWORD
fi

if [ `docker images cicd_arduinocli:latest|wc -l` -lt 2 ];then
	docker-compose -p cicd -f docker/docker-compose.yml build
fi
#the used docker image ( will not pulled )
echo "JENKINS_ADMIN_ID=${JENKINS_ADMIN_ID}" >> ${COMPOSE_ENV_FILE}
echo 'arduinocli_image=cicd_arduinocli:latest' >> ${COMPOSE_ENV_FILE}
echo 'DOCKERCLOUDCONNECTION=unix:///var/run/docker.sock' >> ${COMPOSE_ENV_FILE}
echo 'CASC_JENKINS_CONFIG=/usr/share/jenkins/ref/JCASC'  >> ${COMPOSE_ENV_FILE}
echo "DOCKERHOSTNAME=`hostname -s`"  >> ${COMPOSE_ENV_FILE}
echo "DOCKERNETWORK=cicd_default" >> ${COMPOSE_ENV_FILE}
echo 'ARDOINOREP=https://github.com/luckyonesl/arduino_projects.git' >> ${COMPOSE_ENV_FILE}
echo "SSH_JENKINS_PUB_FILE=${WKDIR}/docker/secrets/id_rsajenkins.pub"  >> ${COMPOSE_ENV_FILE}
#bind mot must be added to make it useable....
echo 'SHAREDLIBREP=https://github.com/luckyonesl/Jenkins_sharedlib.git'  >> ${COMPOSE_ENV_FILE}
echo 'JAVA_OPTS=-Djenkins.install.runSetupWizard=false'  >> ${COMPOSE_ENV_FILE}

#can be used to track wer it comes from ...
echo "JENKINS_DEPLOYMENT_ID=1" >> ${COMPOSE_ENV_FILE}
cd docker && docker-compose -p cicd up --build -d jenkins
