#!/bin/bash
set -e
WKDIR=$(cd "$(dirname "$0")"; pwd -P)

#prepare ssh keys for usage inside jenkins
export SSH_JENKINS_PASSWORD=''
#create the arduino docker builder
if [ ! -f docker/secrets/id_rsajenkins ];then
	#generating key
	ssh-keygen -N "${SSH_JENKINS_PASSWORD}" -f docker/secrets/id_rsajenkins
fi
export SSH_JENKINS_KEY=`cat docker/secrets/id_rsajenkins`

export JENKINS_ADMIN_ID=jadmin
if [ ! -f docker/secrets/JENKINS_ADMIN_PASSWORD ];then
   JENKINS_ADMIN_PASSWORD=`openssl rand -base64 14` > docker/secrets/JENKINS_ADMIN_PASSWORD
   export JENKINS_ADMIN_PASSWORD=`cat docker/secrets/JENKINS_ADMIN_PASSWORD`
fi

if [ `docker images cicd_arduinocli:latest|wc -l` -lt 2 ];then
	docker-compose -p cicd -f docker/docker-compose.yml build
fi
#the used docker image ( will not pulled )
export arduinocli_image=cicd_arduinocli:latest	
#maybe value must be quoted
export DOCKERCLOUDCONNECTION=unix://${WKDIR}/Library/Containers/com.docker.docker/Data/docker.raw.sock

export JENKINS_HOME=./JENKINSHOME
export CASC_JENKINS_CONFIG=${WKDIR}/docker/jenkins/JCASC/
export JENKINS_DEPLOYMENT_ID=1

if [ ! -f /tmp/jenkins.war ];then
	curl http://ftp-nyc.osuosl.org/pub/jenkins/war-stable/2.249.3/jenkins.war -o /tmp/jenkins.war
fi
if [ ! -f /tmp/jenkins-plugin-manager-2.1.3.jar ];then 
	curl -L https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.1.3/jenkins-plugin-manager-2.1.3.jar -o /tmp/jenkins-plugin-manager-2.1.3.jar
fi

if [ ! -d ${JENKINS_HOME} ];then
	mkdir -p ${JENKINS_HOME}
	java -jar /tmp/jenkins-plugin-manager-2.1.3.jar --verbose --skip-failed-plugins --plugin-download-directory ${JENKINS_HOME}/plugins/ --plugin-file docker/jenkins/plugins.txt --war /tmp/jenkins.war
fi

export SHAREDLIBREP=https://github.com/luckyonesl/Jenkins_sharedlib.git
echo "SHAREDLIBREP ${SHAREDLIBREP}"
export ARDOINOREP='https://github.com/luckyonesl/arduino_projects.git' 
java -Djenkins.install.runSetupWizard=false -jar /tmp/jenkins.war --enable-future-java --httpPort=8081
