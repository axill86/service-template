
BUILD_IMAGE := golang:1.13
OS := $(if $(GOOS),$(GOOS),$(shell go env GOOS))
ARCH := $(if $(GOARCH),$(GOARCH),$(shell go env GOARCH))
OUTDIR := bin

.PHONY: clean build all

define ENV
@echo 'Docker image: ${BUILD_IMAGE}'
@echo 'OS          : ${OS}'
@echo 'ARCH        : ${ARCH}'
endef

all: clean build
clean:
	@rm -rf .go
	@rm -rf bin
build:
	@echo 'building project'
	$(ENV)
	docker run --rm  \
	-u $$(id -u):$$(id -g) \
	-v $$(pwd):/src \
	-v $$(pwd)/.go/bin:/go/bin                \
    -v $$(pwd)/.go/cache:/.cache                       \
    --env ARCH=${ARCH} \
    --env OS=${OS} \
	-w /src \
	$(BUILD_IMAGE) /bin/sh "./scripts/build.sh"
	[[ -d $(OUTDIR) ]] || mkdir $(OUTDIR)
	rm -rf $(OUTDIR)/*
	cp -r ./.go/bin/ $(OUTDIR)

run:
	@echo 'building project'
	$(ENV)
	docker run --rm  \
	-u $$(id -u):$$(id -g) \
	-v $$(pwd):/src \
	-v $$(pwd)/.go/bin/$(OS)_$(ARCH):/go/bin                \
    -v $$(pwd)/.go/cache:/.cache                       \
    --env ARCH=${ARCH} \
    --env OS=${OS} \
	-w /src \
	$(BUILD_IMAGE) /bin/sh "./scripts/run.sh"