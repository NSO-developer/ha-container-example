# Containerized NSO Example - HA
Example usecase of running HA with Containerized NSO

## Useage
The Makefile have the following target  
build:  
Build the container enviorment  

deep_clean:   
deep_clean will call the following target 
clean_log clean_run clean  

clean:  
clean will remove all the docker images  

clean_run:  
clean the NSO-vol directory

clean_log:  
clean the NSO-log-vol directory  

clean_CDB:  
clean the *.cdb file in NSO-log/run/cdb directory

stop:  
stop all container with docker-compose

start:  
start all container with docker-compose 

compile_packages:  
compile the packages inside the developer conainter  

cli-c_nso1:  
start Cisco style CLI on Primary NSO1

cli-c_nso2:  
start Cisco style CLI on Secondary NSO2

cli-j_nso1:  
start Juniper style CLI on Primary NSO1

cli-j_nso2:  
start Juniper style CLI on Secondary NSO2

## Use Case
1. Copy the development and production image in the images folder
2. Set Python dependency in requirements.txt
3. Set the dependency that need to be installed via yum and dnf in Dockerfile
4. "make build" to build the enviorment and import the images
5. Start containers and bring up the HA with "make start" 
6. Build the packages in the development images "make compile_packages"
7. Test the packages inside the production images "make cli-c_nso1/nso2" or Juniper CLI "make 
cli-j_nso1/nso2"
