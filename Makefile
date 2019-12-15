cnf ?= config.env
include $(cnf)

default: build

GIT_BRANCH ?= `git rev-parse --abbrev-ref HEAD`
GIT_COMMIT ?= `git rev-parse --short HEAD`

ifeq ($(GIT_BRANCH), master)
  IMAGE_TAG = $(VERSION)
  PUSH_LATEST_TAG = true
else
  IMAGE_TAG = $(GIT_COMMIT)
endif

RUN = docker run $(IMAGE_NAME):latest

build:
	docker build \
		--build-arg CREATED=`date -u +"%Y-%m-%dT%H:%M:%SZ"` \
		--build-arg REVISION=$(GIT_COMMIT) \
		--build-arg VERSION=$(VERSION) \
		--build-arg IMAGE_NAME=$(IMAGE_NAME) \
		-t $(IMAGE_NAME):$(GIT_COMMIT) \
		-t $(IMAGE_NAME):$(IMAGE_TAG) \
		-t $(IMAGE_NAME):latest .

push:
	docker push $(IMAGE_NAME):$(IMAGE_TAG)
	if [ -n "$(PUSH_LATEST_TAG)" ]; then docker push $(IMAGE_NAME):latest; fi

version:
	$(RUN) --version

test:
	$(RUN)

.PHONY: \
	build \
	push \
	version \
	test
