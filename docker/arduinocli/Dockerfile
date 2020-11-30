#FROM raspbian/stretch
FROM debian
RUN apt-get update && apt-get -y install ca-certificates python3 lsof screen sudo openssh-server default-jdk git
ARG ARDOINO_CLI=arduino-cli_nightly-latest_Linux_64bit.tar.gz
ENV ARDOINO_CLI=${ARDOINO_CLI}

RUN useradd -m jenkins-slave
RUN mkdir /home/jenkins-slave/.ssh
#COPY secrets/id_rsajenkins.pub  /home/jenkins-slave/.ssh/authorized_keys
RUN chown -R jenkins-slave /home/jenkins-slave
RUN chmod -R 700 /home/jenkins-slave/.ssh
#RUN chown jenkins-slave /home/jenkins-slave/.ssh/authorized_keys 
#RUN chown jenkins-slave /home/jenkins-slave/.ssh/
RUN echo 'jenkins-slave ALL=(ALL) NOPASSWD: ALL' > /etc/sudoers.d/jenkins


ADD "https://downloads.arduino.cc/arduino-cli/nightly/${ARDOINO_CLI}" /usr/local/arduino-cli/
RUN tar -C  /usr/local/arduino-cli/ -xzvf /usr/local/arduino-cli/${ARDOINO_CLI}
RUN rm /usr/local/arduino-cli/$ARDOINO_CLI
RUN echo 'export PATH=/usr/local/arduino-cli:${PATH}' > /home/jenkins-slave/.bashrc 
USER jenkins-slave
#write stuff to /home/builder/.arduino15/arduino-cli.yaml or exec cmd step by step
#arduino-cli config init --additional-urls http://arduino.esp8266.com/stable/package_esp8266com_index.json
# --config-file for commands
RUN /usr/local/arduino-cli/arduino-cli config init --additional-urls https://arduino.esp8266.com/stable/package_esp8266com_index.json
RUN /usr/local/arduino-cli/arduino-cli core install esp8266:esp8266
RUN /usr/local/arduino-cli/arduino-cli lib install PubSubClient RTCVars Ticker "BlueDot BME280 Library"

COPY entrypoint.sh /
ENTRYPOINT /entrypoint.sh
