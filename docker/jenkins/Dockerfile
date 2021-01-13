FROM jenkins/jenkins:lts
#USER jenkins
COPY known_hosts /usr/share/jenkins/ref/.ssh/known_hosts
COPY plugins.txt /usr/share/jenkins/ref/
#by default it's in latest https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.1.3/jenkins-plugin-manager-2.1.3.jar
#-Dhttps.proxyHost=${HTTP_PROXY_HOST} -Dhttps.proxyPort=${HTTP_PROXY_PORT}
RUN jenkins-plugin-cli --verbose --latest-specified --plugin-download-directory /usr/share/jenkins/ref/plugins/ --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY JCASC /usr/share/jenkins/ref/JCASC
#to use provide
#ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/JCASC
#to skip inital pwd 
#ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
USER root
#install docker to be able to run example2
#RUN curl -sSL https://get.docker.com/ | sh
#RUN apt-get update
RUN export DEBIAN_FRONTEND=noninteractive && apt-get install -y -qq apt-transport-https ca-certificates curl
RUN curl -fsSL https://download.docker.com/linux/debian/gpg | apt-key add -qq -
RUN echo 'deb [arch=amd64] https://download.docker.com/linux/debian stretch stable' > /etc/apt/sources.list.d/docker.list
RUN apt-get update -qq
RUN apt-get install -y -qq --no-install-recommends docker-ce

#RUN usermod -a -G root jenkins
#USER jenkins
