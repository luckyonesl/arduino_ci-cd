# technical documentation

to use this assembly you need a unix filesystem and a docker installation on top of your os and a raspi that is in charge of flashing your arduino device that can be done with any other jenkins slave too.

at the toplevel there are two scripts:

1. [start_ci_cd_arduino_as_compose.sh](../start_ci_cd_arduino_as_compose.sh)
this script start as a jenkins as a docker container the jenkins will then create other docker container as jenkins slaves.

2. [start_ci_cd_arduino.sh](../start_ci_cd_arduino.sh)
this script download the jenkins.war and all plugins and start in the userspace direct a jenkins that will create slaves via docker.

Variable used in the scripts

Variable          | intended usage        | example value
------------------|-----------------------|--------------
 COMPOSE_ENV_FILE | points to an env file | docker/jenkins_environment
 SSH_JENKINS_PASSWORD | password for ssh key | testwas123
 SSH_JENKINS_KEY | private ssh key for jenkins | <content of key>
 arduinocli_image|points to a docker image that should be used|cicd_arduinocli:latest
 DOCKERCLOUDCONNECTION|points to a docker server|unix:///var/run/docker.sock
 CASC_JENKINS_CONFIG|points to the casc location in the jenkins image| /usr/share/jenkins/ref/JCASC
 DOCKERNETWORK|network for cloud images| docker_default
 ARDOINOREP|git repo with arduino project|https://github.com/luckyonesl/arduino_projects.git
 SSH_JENKINS_PUB_FILE|points to the pub file|docker/secrets/id_rsajenkins.pub
 SHAREDLIBREP|git repo for shared lib|https://github.com/luckyonesl/Jenkins_sharedlib.git
 JAVA_OPTS|additional opts for jenkins|-Djenkins.install.runSetupWizard=false
