FROM manicmonkey/raspbian-jdk8
MAINTAINER rcjcooke

# Install everything needed to run the slave (and clean up afterwards to reduce
# the size of the image)!
# To allow Jenkins to SSH to the container: apt-utils openssh-server
RUN sudo apt-get update && sudo apt-get install -y apt-utils \
													openssh-server \
						&& sudo apt-get clean
RUN sudo mkdir -p /var/run/sshd

RUN sudo adduser --quiet --disabled-password --gecos "" jenkins
RUN echo "jenkins:jenkins" | sudo chpasswd

# Install the tools needed to make the slave useful
# To install and allow Git to authenticate: -t wheezy-backports install git
# To resolve Git SSL issue: ca-certificates
# To verify backport packages: get public keys for Debian Wheezy and Jessie
RUN echo "deb http://http.debian.net/debian wheezy-backports main" > /etc/apt/sources.list.d/wheezy-backports.list
RUN gpg --keyserver pgpkeys.mit.edu --recv-key 8B48AD6246925553 7638D0442B90D010 \
		&& gpg -a --export 8B48AD6246925553 | sudo apt-key add - \
		&& gpg -a --export 7638D0442B90D010 | sudo apt-key add -
RUN sudo apt-get update && sudo apt-get -t wheezy-backports install -y git \
						&& sudo apt-get clean
RUN sudo apt-get update && sudo apt-get install -y ca-certificates \
						&& sudo apt-get clean

# Add the docker group to the container with the same GID as the docker group on
# the host. This is to ensure that when we add the jenkins user to the group, it
# gets the same access permissions accessing the daemon socket as the host
# docker engine.
RUN sudo groupadd -g 996 docker

# Install docker in the container for doing docker builds
# Note: You'll need to run the container with
#       -v /var/run/docker.sock:/var/run/docker.sock
RUN sudo apt-get install -y apt-transport-https && \
	wget -q https://packagecloud.io/gpg.key -O - | sudo apt-key add - && \
	echo 'deb https://packagecloud.io/Hypriot/Schatzkiste/debian/ wheezy main' | sudo tee /etc/apt/sources.list.d/hypriot.list && \
	sudo apt-get update && sudo apt-get install -y docker-hypriot && sudo apt-get clean

# The jenkins user needs to be in the docker group so that it can access the
# mounted unix socket to allow it to connect to the host docker daemon without
# requiring root access (otherwise jenkins would need sudo rights and would
# have to execute docker with the sudo command)
RUN sudo usermod -aG docker jenkins

# Make sure the slave is accessible and usable
EXPOSE 22
ENTRYPOINT sudo /usr/sbin/sshd -D
