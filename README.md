# RPi-jenkins-slave
Raspberry Pi Jenkins Docker Slave

Based on manicmonkey/raspbian-jdk8 which is JDK 8 installed on Raspbian:jessie latest.

This image includes:
* Everything needed for Jenkins Docker Plugin to spin this up as a build slave
* Git
* docker-Hypriot (latest version to match the underlying OS install, from https://packagecloud.io/Hypriot/Schatzkiste/debian/)

This needs to spun up with the following volume binding flag for docker to work in-container:

`-v /var/run/docker.sock:/var/run/docker.sock`

The jenkins user needs to be added to the docker user group on the host machine to have permission to execute docker.

## Acknowledgments
* Thanks to the Hypriot team for the Raspberry Pi Docker build
* Thanks to Vishal Sahasrabuddhe for his blog on Jenkins slaves for the host configuration.
