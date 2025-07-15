#!/bin/bash


set -euo pipefail

check_java_version(){
	if ! command -v java &>/dev/null;
	then
		echo "java is not installed"
		return 1
	else
		echo "java is installed with the version"
		java -version
	fi
}

install_java(){
	sudo apt update
	sudo apt install -y fontconfig openjdk-21-jre
}

check_docker_version(){
	if ! command -v docker &>/dev/null;
        then
                echo "docker is not installed"
		return 1
        else
                echo "Docker is already installed with the version"
		docker -v
        fi
}
install_docker(){
	sudo apt-get update
	sudo apt-get -y  install docker.io
	sudo usermod -aG docker $USER
	echo "⚠️  Please log out and log back in to apply Docker group permissions."
}
check_docker_compose_version(){
	if ! command docker compose version &>/dev/null;
        then
                echo "docker compose is not installed"
		return 1
        else
                echo "Docker compose is already installed with the version"
                docker compose version
        fi
}

install_docker_compose(){
	if ! sudo apt-get install docker-compose-plugin &>/dev/null
	then
		sudo apt-get update
		sudo mkdir -p /etc/apt/keyrings
		curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
		echo \
		  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] \
		  https://download.docker.com/linux/ubuntu \
		  $(lsb_release -cs) stable" | \
		  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
		sudo apt-get update
		sudo apt-get install -y  docker-compose-plugin
	fi


}

main(){
	check_java_version || install_java
	check_docker_version || install_docker
	check_docker_compose_version || install_docker_compose
}

main "$@"
