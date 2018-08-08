.PHONY:	proto build push

# Protobuf files are in proto and will build into python definitions in build
PROTO_DIR = proto
BUILD_DIR = build
PROTO_SRC := $(wildcard $(PROTO_DIR)/*.proto)
PROTO_BUF_DEFS := $(patsubst $(PROTO_DIR)/%.proto, $(BUILD_DIR)/%_pb2_grpc.py, $(PROTO_SRC))


# Docker image and tag
IMAGE = prog_image
TAG = latest

# Rule for proto buf files
$(PROTO_BUF_DEFS): $(PROTO_SRC)
	mkdir -p $(BUILD_DIR)
	python -m grpc_tools.protoc -I$(PROTO_DIR) --python_out=${BUILD_DIR} --grpc_python_out=${BUILD_DIR} $<

# Make file target
proto: $(PROTO_BUF_DEFS)

build: $(PROTO_BUF_DEFS)
	docker build --pull -t $(IMAGE):$(TAG) .

push:
	docker push $(PREFIX)/$(IMAGE):$(TAG)

clean:
	rm -Rf $(BUILD_DIR)
