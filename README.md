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
9. Check HA status via "show high-availability" in "make cli-c_nso1/nso2" or Juniper CLI "make cli-j_nso1/nso2"
```
$ make cli-c_nso1
docker exec -it nso1_primary ncs_cli -C -u admin

User admin last logged in 2024-05-24T08:06:51.314469+00:00, to ad7f7a2fc0a4, from 127.0.0.1 using cli-console
admin connected from 127.0.0.1 using console on ad7f7a2fc0a4
admin@ncs# show high-availability 
high-availability enabled
high-availability status mode primary
high-availability status current-id nso1
high-availability status assigned-role primary
high-availability status read-only-mode false
high-availability status connected-secondary nso2
 address 10.0.0.3
```


### Copyright and License Notice
``` 
Copyright (c) 2024 Cisco and/or its affiliates.

This software is licensed to you under the terms of the Cisco Sample
Code License, Version 1.1 (the "License"). You may obtain a copy of the
License at

               https://developer.cisco.com/docs/licenses

All use of the material herein must be in accordance with the terms of
the License. All rights not expressly granted by the License are
reserved. Unless required by applicable law or agreed to separately in
writing, software distributed under the License is distributed on an "AS
IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express
or implied.
``` 