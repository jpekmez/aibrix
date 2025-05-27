#!/bin/bash

set -euxo pipefail

K3S_TAG=${K3S_TAG:="v1.30.13-k3s1"}
CUDA_TAG=${CUDA_TAG:="12.8.1-base-ubuntu22.04"}
IMAGE_REGISTRY=${IMAGE_REGISTRY:="us-central1-docker.pkg.dev/cohere-artifacts/cohere"}
IMAGE_REPOSITORY=${IMAGE_REPOSITORY:="jeremy/k3d-gpu"}
IMAGE_TAG="$K3S_TAG-cuda-$CUDA_TAG"
IMAGE=${IMAGE:="$IMAGE_REGISTRY/$IMAGE_REPOSITORY:$IMAGE_TAG"}

echo "IMAGE=$IMAGE"

docker build \
  --build-arg K3S_TAG=$K3S_TAG \
  --build-arg CUDA_TAG=$CUDA_TAG \
  -t $IMAGE .
docker push $IMAGE
echo "Done!"