#!/bin/bash

# Deploy Ollama in Codespaces with optimized resource settings
# This script uses lower resource allocations suitable for GitHub Codespaces

echo "========================================"
echo "   Ollama Codespaces Deployment Tool   "
echo "========================================"

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
STANDARD_DIR="$BASE_DIR/k8s/standard"
CODESPACES_DIR="$BASE_DIR/k8s/codespaces"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
  if command -v minikube &> /dev/null; then
    # If using minikube, set the kubectl alias
    echo "Using minikube kubectl..."
    KUBECTL="minikube kubectl --"
  else
    echo "kubectl not found. Please install kubectl or minikube and try again."
    exit 1
  fi
else
  # Set kubectl path dynamically
  KUBECTL=$(which kubectl)
fi

# Function to check if namespace exists
check_namespace() {
  $KUBECTL get namespace ollama &> /dev/null
  return $?
}

# Function to deploy everything
deploy_all() {
  echo -e "\n[1/6] Creating namespace..."
  $KUBECTL apply -f "$STANDARD_DIR/namespace.yaml"
  
  echo -e "\n[2/6] Creating persistent volume claim for configuration..."
  $KUBECTL apply -f "$STANDARD_DIR/pvc.yaml"
  
  echo -e "\n[3/6] Creating persistent volume claim for models..."
  $KUBECTL apply -f "$CODESPACES_DIR/models-pvc.yaml"
  
  echo -e "\n[4/6] Deploying Ollama (Codespaces-optimized)..."
  $KUBECTL apply -f "$CODESPACES_DIR/deployment.yaml"
  
  echo -e "\n[5/6] Creating Ollama service..."
  $KUBECTL apply -f "$STANDARD_DIR/service.yaml"
  
  echo -e "\n[6/6] Deploying Web UI (Codespaces-optimized)..."
  $KUBECTL apply -f "$CODESPACES_DIR/webui-deployment.yaml"
  $KUBECTL apply -f "$STANDARD_DIR/webui-service.yaml"
  
  echo -e "\n✅ Deployment complete!"
}

# Deploy if needed
if ! check_namespace; then
  echo "Ollama namespace not found. Setting up from scratch..."
  deploy_all
else
  echo "Ollama namespace already exists."
  echo "Would you like to redeploy everything? (y/n)"
  read -r answer
  if [[ $answer == "y" ]]; then
    deploy_all
  fi
fi

# Check pod status
echo -e "\nChecking deployment status..."
$KUBECTL get pods -n ollama
$KUBECTL get svc -n ollama

# Provide next steps
echo -e "\n========================================"
echo "                Next Steps                "
echo "========================================"
echo "1. Wait for pods to be in 'Running' state"
echo "2. Pull a small model: $BASE_DIR/scripts/pull-model.sh phi3-mini"
echo "3. Monitor resources: $BASE_DIR/scripts/monitor.sh"
echo "4. Access WebUI from ports tab or browser preview"
echo "5. Set WebUI API endpoint to: http://ollama:11434"
echo -e "\nFor Codespaces, we recommend using smaller models like:"
echo "  - phi3-mini       (3.8B parameters, compact but powerful)"
echo "  - mistral:7b      (7B parameters, good general purpose model)"
echo "  - codellama:7b    (7B parameters, optimized for coding tasks)"
echo "  - llama3:8b       (8B parameters, Meta's latest general model)"
echo -e "\nSee $BASE_DIR/docs/CODESPACES.md for more information."
