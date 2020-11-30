FROM jenkins/jenkins:2.267
#USER jenkins
COPY known_hosts /usr/share/jenkins/ref/.ssh/known_hosts
COPY plugins.txt /usr/share/jenkins/ref/
#by default it's in latest https://github.com/jenkinsci/plugin-installation-manager-tool/releases/download/2.1.3/jenkins-plugin-manager-2.1.3.jar
RUN jenkins-plugin-cli --verbose --skip-failed-plugins --plugin-download-directory /usr/share/jenkins/ref/plugins/ --plugin-file /usr/share/jenkins/ref/plugins.txt
COPY JCASC /usr/share/jenkins/ref/JCASC
#to use provide
#ENV CASC_JENKINS_CONFIG /usr/share/jenkins/ref/JCASC
#to skip inital pwd 
#ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false
USER root
#install docker to be able to run example2
RUN curl -sSL https://get.docker.com/ | sh
#RUN usermod -a -G root jenkins
#USER jenkins
