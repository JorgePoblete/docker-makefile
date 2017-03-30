# This will silence the make file, similar to add @
$(VERBOSE).SILENT:

######################################
######## Customizable options ########
######################################

# the name of the builded docker image
IMAGE_NAME=docker-image

# the name of the builded docker container
CONTAINER_NAME=docker-base

# the hostname of the container,
# this will show you a promp like
# 'root@Docker:#' inside the conainer
HOSTNAME=Docker

# docker params to build the image
BUILD_PARAMS=-t

# docker params to run the container
RUN_PARAMS=-it -h $(HOSTNAME)

# path where the Dockerfile is
DOCKERFILE_PATH=.

# docker executable, added if for some reason you have your docker exec file somewhere else
DOCKER_EXEC=docker


######################################
############ System calls ############
######################################

RUNNING=$$($(DOCKER_EXEC) ps | grep $(CONTAINER_NAME) | awk '{print $$1}')
BACKRUNNING=$$($(DOCKER_EXEC) -a | grep $(CONTAINER_NAME) | awk '{print $$1}')
BUILDED=$$($(DOCKER_EXEC) images | grep $(IMAGE_NAME))


######################################
############ Make targets ############
######################################

build:
	DPID=$(call BUILDED); \
	if [ ! "$$DPID" ]; then \
		$(DOCKER_EXEC) build $(BUILD_PARAMS) $(IMAGE_NAME) $(DOCKERFILE_PATH); \
	fi

run:
	${MAKE} build; \
	DPID=$(call BACKRUNNING); \
	if [ ! "$$DPID" ]; then \
		DPID=$(call RUNNING); \
		if [ ! "$$DPID" ]; then \
			$(DOCKER_EXEC) run $(RUN_PARAMS) --name $(CONTAINER_NAME) $(IMAGE_NAME); \
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
		$(DOCKER_EXEC) attach $(CONTAINER_NAME); \
	fi

rmi:
	DPID=$(call BUILDED); \
	if [ "$$DPID" ]; then \
		$(DOCKER_EXEC) rmi $(IMAGE_NAME); \
	fi

rm:
	DPID=$(call BACKRUNNING); \
	if [ "$$DPID" ]; then \
		$(DOCKER_EXEC) rm $(CONTAINER_NAME); \
	fi

clean:
	${MAKE} rm; \
	${MAKE} rmi;

start:
	DPID=$(call RUNNING); \
	if [ ! "$$DPID" ]; then \
		$(DOCKER_EXEC) start $(CONTAINER_NAME); \
	fi

stop:
	DPID=$(call RUNNING); \
	if [ "$$DPID" ]; then \
		$(DOCKER_EXEC) stop $(CONTAINER_NAME); \
	fi
