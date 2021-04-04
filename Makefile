export USER_ID := $(shell id -u)
export USER_NAME := devops
export GROUP_ID := $(shell id -g)
export GROUP_NAME := devops
export AWS_PROFILE := zenika-clevandowski-api
export AWS_REGION := eu-west-3

build:
	docker image build \
		-t cloud-tooling-kafka:dont.push.this.image \
		--build-arg USER_ID=$$USER_ID \
		--build-arg USER_NAME=$$USER_NAME \
		--build-arg GROUP_ID=$$GROUP_ID \
		--build-arg GROUP_NAME=$$GROUP_NAME \
		.
	echo "Build finished, never push this image"

run: build
	docker container run --rm -ti \
		--name cloud-tooling-kafka-$$$$ \
		--env AWS_PROFILE="$$AWS_PROFILE" \
		--env AWS_REGION="$$AWS_REGION" \
		-v $$HOME/.ssh:/home/$$USER_NAME/.ssh:ro \
		-v $$HOME/.aws:/home/$$USER_NAME/.aws:ro \
		-v $$HOME/.gitconfig:/home/$$USER_NAME/.gitconfig:ro \
		-v $$PWD:/home/$$USER_NAME/main \
		cloud-tooling-kafka:dont.push.this.image

clean:
	docker image rm cloud-tooling-kafka:dont.push.this.image
