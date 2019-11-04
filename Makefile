
BUILD_IMAGE := golang:1.13
OS := $(if $(GOOS),$(GOOS),$(shell go env GOOS))
ARCH := $(if $(GOARCH),$(GOARCH),$(shell go env GOARCH))

.PHONY: clean build all
all: clean build
clean:
	@rm -rf .go
build:
	@echo 'building project'
	@echo 'Docker image: ${BUILD_IMAGE}'
	@echo 'OS          : ${OS}'
	@echo 'ARCH        : ${ARCH}'
	docker run --rm  \
	-u $$(id -u):$$(id -g) \
	-v $$(pwd):/src \
	-v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
    -v $$(pwd)/.go/cache:/.cache                       \
    --env ARCH=${ARCH} \
    --env OS=${OS} \
	-w /src \
	$(BUILD_IMAGE) /bin/sh "./scripts/build.sh"
