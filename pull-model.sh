#!/bin/bash

# Script to pull Ollama models in Kubernetes
# Usage: ./pull-model.sh <model-name>

if [ -z "$1" ]; then
  echo "Usage: ./pull-model.sh <model-name>"
  echo "Example: ./pull-model.sh llama2"
  exit 1
fi

MODEL=$1

# Get the pod name
POD=$(/Users/idv/.rd/bin/kubectl get pods -n ollama -l app=ollama -o jsonpath='{.items[0].metadata.name}')

if [ -z "$POD" ]; then
  echo "No Ollama pod found. Make sure the deployment is running."
  exit 1
fi

echo "Pulling model $MODEL on pod $POD..."
/Users/idv/.rd/bin/kubectl exec -it -n ollama $POD -- ollama pull $MODEL

echo "Model $MODEL pulled successfully!"
