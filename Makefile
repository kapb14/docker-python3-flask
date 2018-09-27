.PHONY: clean build run stop inspect push simple-build up

IMAGE_NAME = kapb14/docker-python3-flask
CONTAINER_NAME = python3-flask

release: build push

dev-build:
		docker build -t $(IMAGE_NAME) .

build:
		docker build --build-arg VCS_REF=`git rev-parse --short HEAD` --build-arg BUILD_DATE=`date -u +"%Y-%m-%dT%H:%M:%SZ"` -t $(IMAGE_NAME) .

up:
		docker run --rm -p 55000:55000 --name $(CONTAINER_NAME) $(IMAGE_NAME)

inspect:
		docker inspect $(IMAGE_NAME)

run:
		docker run --rm -it --entrypoint bash --user root -v `pwd`/opt:/opt $(IMAGE_NAME)

shell:
		docker exec -it $(CONTAINER_NAME) /bin/bash

stop:
		docker stop $(CONTAINER_NAME)

clean:
		docker ps -a | grep '$(CONTAINER_NAME)' | awk '{print $$1}' | xargs docker rm \
				docker images | grep '$(IMAGE_NAME)' | awk '{print $$3}' | xargs docker rmi

push:
		docker push $(IMAGE_NAME)





