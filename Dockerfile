FROM hypriot/rpi-java

# Install everything needed to run the slave and Install the tools needed to make the slave useful (and clean up afterwards to reduce the size of the image)!
echo "deb http://http.debian.net/debian wheezy-backports main" > /etc/apt/sources.list.d/wheezy-backports.list
RUN sudo apt-get update -qq && sudo apt-get install -y apt-utils openssh-server && sudo apt-get -t wheezy-backports install git && sudo apt-get clean
RUN sudo mkdir -p /var/run/sshd
RUN sudo adduser --quiet --disabled-password --gecos "" jenkins
RUN echo "jenkins:jenkins" | sudo chpasswd

# Make sure the slave is accessible and usable
EXPOSE 22
ENTRYPOINT sudo /usr/sbin/sshd -D