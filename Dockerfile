FROM golang:1.23.1-bullseye AS go-builder

# Set Golang environment variables.
ENV GOPATH=/go
ENV PATH=$PATH:/go/bin

# Install dependencies
ENV PACKAGES git make gcc musl-dev wget ca-certificates build-essential
RUN apt-get update
RUN apt-get install -y $PACKAGES

# Update ca certs
RUN update-ca-certificates

# renovate: datasource=github-releases depName=babylonchain/babylon
ARG VERSION=v1.0.0-rc.3

# for COSMWASM_VERSION check here https://github.com/babylonchain/babylon/blob/dev/go.mod
ARG COSMWASM_VERSION=v0.53.0

# for COSMWASM_VM_VERSION be sure to check the compatibility section in the README.md file here (https://github.com/CosmWasm/wasmd)
ARG COSMWASM_VM_VERSION=v2.1.2

# you may also need to update this path - can check it here https://github.com/CosmWasm/wasmd/blob/master/go.mod
# if the build fails in CI you can build it locally using "DOCKER_BUILDKIT=0 docker build ." and copy the output from the find command below
ARG COSMWASM_PATH=/go/pkg/mod/github.com/!cosm!wasm/wasmvm/v2@$COSMWASM_VM_VERSION/internal/api/libwasmvm.x86_64.so

# Install cosmwasm lib
RUN git clone https://github.com/CosmWasm/wasmd.git \
    && cd wasmd \
    && git checkout $COSMWASM_VERSION \
    && go mod download \
    && go mod tidy && make install \
    && find / -name libwasmvm.x86_64.so \
    && cp $COSMWASM_PATH /usr/lib

RUN git clone https://github.com/babylonlabs-io/babylon.git \
    && cd babylon \
    && git checkout tags/$VERSION \
    && make build \
    && make install

# Final image
FROM ubuntu:jammy

# Install ca-certificates
RUN apt-get update && apt-get install -y ca-certificates curl wget jq git 

COPY --from=go-builder /usr/lib/libwasmvm.x86_64.so /usr/lib
COPY --from=go-builder /go/bin/babylond /usr/bin/babylond

# Run the binary.
CMD ["/bin/sh"]

COPY . .

ENV SHELL /bin/bash
