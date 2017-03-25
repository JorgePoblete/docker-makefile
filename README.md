# Docker Makefile

Basic is a basic Makefile to use with docker, it contains the following targets:

- build: Build the docker image if its not already builded.
- run: Creates a new container using the docker image builded in the previous step, if the container has already been created this will start and attach to the container instead.
- start: Starts the container if it is not already running.
- stop: Stops the container if it is running.
- attach: Attach to the container, if its not builded or started it will build or start the container and then attach to it.
- rm: Deletes the container.
- rmi: Deletes the docker image.
- clean: Deletes the container and the docker image.
