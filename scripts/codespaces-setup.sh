#!/bin/bash

# Codespaces Kubernetes Setup Script
# This script will set up a local Kubernetes cluster in GitHub Codespaces

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

echo "========================================"
echo "     Ollama Codespaces K8s Setup        "
echo "========================================"

# Check if running in Codespaces
if [ -z "$CODESPACES" ]; then
  echo "Not running in GitHub Codespaces. This script is designed for Codespaces environment."
  echo "You can still use it, but it might not work as expected."
  read -p "Continue anyway? (y/n): " -n 1 -r
  echo
  if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    exit 1
  fi
fi

# Start Minikube cluster
echo "Starting Minikube Kubernetes cluster..."
minikube start --driver=docker --memory=6g --cpus=2

# Set kubectl to use minikube context
eval $(minikube -p minikube docker-env)

# Create alias for easier access
echo "Setting up kubectl alias..."
alias kubectl="minikube kubectl --"

# Verify the cluster is running
echo "Verifying cluster status..."
minikube status
kubectl get nodes

echo ""
echo "========================================"
echo "Kubernetes cluster is ready!"
echo "========================================"
echo "NEXT STEPS:"
echo "1. Run: $BASE_DIR/scripts/codespaces-start.sh"
echo "   This will deploy Ollama with optimized settings for Codespaces"
echo ""
echo "2. Alternatively, run: $BASE_DIR/scripts/start.sh"
echo "   This will deploy Ollama with default settings (higher resource usage)"
echo "========================================"
echo "To access kubectl, use: minikube kubectl -- <command>"
echo "or run: alias kubectl='minikube kubectl --'"
echo "========================================"
