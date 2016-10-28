image_name := aws-auth-proxy
image_registry := quay.io/nordstrom
aws_auth_proxy_version := 0.0.1
image_release := $(aws_auth_proxy_version)

ifdef http_proxy
build_args := --build-arg="http_proxy=$(http_proxy)"
build_args += --build-arg="https_proxy=$(http_proxy)"
endif

build := $(PWD)/build

.PHONY: build/image tag/image push/image

build/image: $(build)/aws-auth-proxy Dockerfile
	docker build -t $(image_name) $(build_args) .

tag/image: build/image
	docker tag $(image_name) $(image_registry)/$(image_name):$(image_release)

push/image: tag/image
	docker push $(image_registry)/$(image_name):$(image_release)

$(build)/aws-auth-proxy: $(GOPATH)/src/github.com/coreos/aws-auth-proxy | $(build) go
	GOOS=linux GOARCH=amd64 go build -o "$@" github.com/coreos/aws-auth-proxy

$(GOPATH)/src/github.com/coreos/aws-auth-proxy: | go
	go get github.com/coreos/aws-auth-proxy

$(build):
	mkdir -p $@

clean:
	rm -rf $(build)

go: /usr/local/bin/go

/usr/local/bin/go:
	brew install go
