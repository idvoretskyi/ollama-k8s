#!/bin/bash

# One-click startup script for Ollama Kubernetes

echo "========================================"
echo "      Ollama Kubernetes Quick Start     "
echo "========================================"

# Check if kubectl is available
if ! command -v kubectl &> /dev/null; then
    echo "kubectl not found. Please install kubectl and try again."
    exit 1
fi

# Set kubectl path
KUBECTL="/Users/idv/.rd/bin/kubectl"

# Function to check if namespace exists
check_namespace() {
    $KUBECTL get namespace ollama &> /dev/null
    return $?
}

# Function to deploy everything
deploy_all() {
    echo -e "\n[1/5] Creating namespace..."
    $KUBECTL apply -f namespace.yaml
    
    echo -e "\n[2/5] Creating persistent volume claim..."
    $KUBECTL apply -f pvc.yaml
    
    echo -e "\n[3/5] Deploying Ollama..."
    $KUBECTL apply -f deployment.yaml
    
    echo -e "\n[4/5] Creating Ollama service..."
    $KUBECTL apply -f service.yaml
    
    echo -e "\n[5/5] Deploying Web UI..."
    $KUBECTL apply -f webui-deployment.yaml
    $KUBECTL apply -f webui-service.yaml
    
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
echo "2. Pull a model: ./pull-model.sh llama2"
echo "3. Monitor resources: ./monitor.sh"
echo "4. Access WebUI: http://$(kubectl get svc -n ollama ollama-webui -o jsonpath='{.status.loadBalancer.ingress[0].ip}'):8080"
echo "5. Set WebUI API endpoint to: http://ollama:11434"
echo -e "\nSee GETTING-STARTED.md for more information."
