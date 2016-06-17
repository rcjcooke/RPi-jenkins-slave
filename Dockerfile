FROM hypriot/rpi-java

# Install everything needed to run the slave
RUN sudo apt-get update -qq && sudo apt-get install -y apt-utils openssh-server
RUN sudo mkdir -p /var/run/sshd
RUN sudo adduser --quiet --disabled-password --gecos "" jenkins
RUN echo "jenkins:jenkins" | sudo chpasswd

# Install the tools needed to make the slave useful (and clean up afterwards to reduce the size of the image)!
RUN sudo apt-get install git-all && sudo apt-get clean

# Make sure the slave is accessible and usable
EXPOSE 22
ENTRYPOINT sudo /usr/sbin/sshd -D