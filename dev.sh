#!/bin/bash

set -e

GIT_COMMIT_HASH=$(git rev-parse HEAD)

export AIBRIX_CONTAINER_REGISTRY_NAMESPACE=us-central1-docker.pkg.dev/cohere-artifacts/cohere
make docker-build-all && make docker-push-all

echo "kustomize edit"

cd config/default
kustomize edit set image runtime=$AIBRIX_CONTAINER_REGISTRY_NAMESPACE/runtime:$GIT_COMMIT_HASH
kustomize edit set image kvcache-watcher=$AIBRIX_CONTAINER_REGISTRY_NAMESPACE/kvcache-watcher:$GIT_COMMIT_HASH
kustomize edit set image controller=$AIBRIX_CONTAINER_REGISTRY_NAMESPACE/controller-manager:$GIT_COMMIT_HASH
kustomize edit set image gateway-plugins=$AIBRIX_CONTAINER_REGISTRY_NAMESPACE/gateway-plugins:$GIT_COMMIT_HASH
kustomize edit set image metadata-service=$AIBRIX_CONTAINER_REGISTRY_NAMESPACE/metadata-service:$GIT_COMMIT_HASH

echo "kubectl apply"

cd ../..
# kubectl apply -k config/dependency --server-side
kubectl apply -k config/default
