# the name of the builded docker image
IMAGE_NAME=docker-image

# the name of the builded docker container
CONTAINER_NAME=docker-base

# the hostname of the container,
# this will show you a promp like
# 'root@Docker:#' inside the conainer
HOSTNAME=Docker

RUNNING=$$(docker ps | grep $(CONTAINER_NAME) | awk '{print $$1}')
BACKRUNNING=$$(docker ps -a | grep $(CONTAINER_NAME) | awk '{print $$1}')
BUILDED=$$(docker images | grep $(IMAGE_NAME))

$(VERBOSE).SILENT:

build:
	DPID=$(call BUILDED); \
	if [ ! "$$DPID" ]; then \
		docker build -t $(IMAGE_NAME) .; \
	fi

run:
	${MAKE} build; \
	DPID=$(call BACKRUNNING); \
	if [ ! "$$DPID" ]; then \
		DPID=$(call RUNNING); \
		if [ ! "$$DPID" ]; then \
			docker run -it -h $(HOSTNAME) --name $(CONTAINER_NAME) $(IMAGE_NAME); \
		fi; \
	fi

attach:
	DPID=$(call BACKRUNNING); \
	if [ ! "$$DPID" ]; then \
		${MAKE} run; \
	else \
		DPID=$(call RUNNING); \
		if [ ! "$$DPID" ]; then \
			${MAKE} start; \
		fi; \
		docker attach $(CONTAINER_NAME); \
	fi

rmi:
	DPID=$(call BUILDED); \
	if [ "$$DPID" ]; then \
		docker rmi $(IMAGE_NAME); \
	fi

rm:
	DPID=$(call BACKRUNNING); \
	if [ "$$DPID" ]; then \
		docker rm $(CONTAINER_NAME); \
	fi

clean:
	${MAKE} rm; \
	${MAKE} rmi;

start:
	DPID=$(call RUNNING); \
	if [ ! "$$DPID" ]; then \
		docker start $(CONTAINER_NAME); \
	fi

stop:
	DPID=$(call RUNNING); \
	if [ "$$DPID" ]; then \
		docker stop $(CONTAINER_NAME); \
	fi
