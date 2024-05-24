# NSO Example - Containerized HA
NSO can be deployed in your environment using a container, such as Docker. This repository shows a example use case of running built-in HA with Containerized NSO. It also present a recommended best practice of using Containerized NSO.

## Usage
The Makefile has the following targets 
 
build:  
Build the container environment  

deep_clean:   
deep_clean will call the following target clean_log clean_run clean  

clean:  
Clean will remove all the docker images  

clean_run:  
Clean the NSO-vol directory

clean_log:  
Clean the NSO-log-vol directory  

clean_CDB:  
Clean the *.cdb file in NSO-log/run/cdb directory

stop:  
Stop all containers with docker-compose

start:  
Start all containers with docker-compose 

compile_packages:  
Compile the packages inside the developer container  

cli-c_nso1:  
start Cisco style CLI on Primary NSO1

cli-c_nso2:  
Start Cisco style CLI on Secondary NSO2

cli-j_nso1:  
Start Juniper style CLI on Primary NSO1

cli-j_nso2:  
Start Juniper style CLI on Secondary NSO2

## Use Case
1. Copy the development and production image in the images folder
2. Set Python dependency in requirements.txt
3. Set the dependencies that need to be installed via yum and dnf in the Dockerfile
4. Modify the "VER" and "ARCH" variable in Makefile. "VER" is the Containerized NSO version and "ARCH" is the CPU Architecture.
5. "make build" to build the environment and import the images
6. Start containers and bring up the HA with "make start"
7. Build the packages in the development images "make compile_packages"
8. Test the packages inside the production images "make cli-c_nso1/nso2" or Juniper CLI "make cli-j_nso1/nso2"
