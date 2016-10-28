FROM quay.io/nordstrom/baseimage-alpine:3.4
MAINTAINER Nordstrom Kubernetes Platform Team "techk8s@nordstrom.com"

COPY build/aws-auth-proxy /usr/bin/aws-auth-proxy

ENTRYPOINT ["/usr/bin/aws-auth-proxy"]
