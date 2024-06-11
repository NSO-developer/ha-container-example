VER="6.2.3"
ENABLED_SERVICES=NSO-1 NSO-2 BUILD-NSO-PKGS
ARCH=x86_64

build: 
	docker load -i ./images/nso-${VER}.container-image-dev.linux.${ARCH}.tar.gz
	docker load -i ./images/nso-${VER}.container-image-prod.linux.${ARCH}.tar.gz
	docker build -t mod-nso-prod:${VER}  --no-cache --network=host --build-arg type="prod"  --build-arg ver=${VER}    --file Dockerfile .
	docker build -t mod-nso-dev:${VER}  --no-cache --network=host --build-arg type="dev"  --build-arg ver=${VER}   --file Dockerfile .
	docker run -d --name nso-prod -e ADMIN_USERNAME=admin -e ADMIN_PASSWORD=admin -e EXTRA_ARGS=--with-package-reload-force  -v ./NSO-log-vol/NSO1:/log:Z mod-nso-prod:${VER}
	bash check_nso1_status.sh
	docker exec nso-prod bash -c 'chmod 777 -R /nso/*'
	docker exec nso-prod bash -c 'chmod 777 -R /log/*'
	docker cp nso-prod:/nso/ NSO-vol/
	mv NSO-vol/nso NSO-vol/NSO1
	rm -rf NSO-vol/nso
	docker stop nso-prod && docker rm nso-prod
	docker run -d --name nso-prod -e ADMIN_USERNAME=admin -e ADMIN_PASSWORD=admin -e EXTRA_ARGS=--with-package-reload-force  -v ./NSO-log-vol/NSO2:/log:Z mod-nso-prod:${VER}
	bash check_nso1_status.sh
	docker exec nso-prod bash -c 'chmod 777 -R /nso/*'
	docker exec nso-prod bash -c 'chmod 777 -R /log/*'
	docker cp nso-prod:/nso/ NSO-vol/
	mv NSO-vol/nso NSO-vol/NSO2
	rm -rf NSO-vol/nso
	docker stop nso-prod && docker rm nso-prod
	cp util/Makefile NSO-vol/NSO1/run/packages/
	cp util/Makefile NSO-vol/NSO2/run/packages/
	cp config/ncs.conf NSO-vol/NSO1/etc/
	cp config/ncs.conf NSO-vol/NSO2/etc/ 
	cp config/device_conf/nso1.xml NSO-vol/NSO1/run/cdb
	cp config/device_conf/nso2.xml NSO-vol/NSO2/run/cdb
	make clean_cdb
	
deep_clean: clean_log clean_run clean

clean: 
	-docker image rm -f cisco-nso-dev:${VER}
	-docker image rm -f cisco-nso-prod:${VER}
	-docker image rm -f mod-nso-prod:${VER}  
	-docker image rm -f mod-nso-dev:${VER} 

clean_run:
	rm -rf ./NSO-vol/* 

clean_log:
	rm -rf ./NSO-log-vol/*/*	

clean_cdb:
	rm  ./NSO-vol/*/run/cdb/*.cdb


start:
	export VER=${VER} ; docker compose up ${ENABLED_SERVICES} -d
	bash check_status.sh
	cd config/ha_enable; sh nso1.sh
	sleep 5
	cd config/ha_enable; sh nso2.sh

stop:
	export VER=${VER} ;docker compose down  ${ENABLED_SERVICES}


compile_packages:
	docker exec -it nso-dev make all -C /nso1/run/packages
	docker exec -it nso-dev make all -C /nso2/run/packages

cli-c_nso1:
	docker exec -it nso1_primary ncs_cli -C -u admin

cli-c_nso2:
	docker exec -it nso2_secondary ncs_cli -C -u admin

cli-j_nso1:
	docker exec -it nso1_primary ncs_cli -J -u admin

cli-j_nso2:
	docker exec -it nso2_secondary ncs_cli -J -u admin
