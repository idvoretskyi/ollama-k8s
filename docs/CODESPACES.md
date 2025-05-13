# Using Ollama-K8s with GitHub Codespaces

This guide explains how to use this repository with GitHub Codespaces, allowing you to run Ollama and LLMs directly in the cloud without installing anything on your local machine.

## Getting Started with Codespaces

### 1. Launch Codespace

Click the button below to open this repository in GitHub Codespaces:

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/idvoretskyi/ollama-k8s)

Alternatively:
1. Navigate to the repository on GitHub
2. Click the "Code" button
3. Select the "Codespaces" tab
4. Click "Create codespace on main"

### 2. Set Up Kubernetes

Once your Codespace is ready, run the setup script to create a local Kubernetes cluster:

```bash
./scripts/codespaces-setup.sh
```

Alternatively, you can use the VS Code Tasks menu (Terminal → Run Task → Setup Kubernetes Cluster).

This will:
- Start a Minikube cluster using Docker
- Configure kubectl to use the Minikube context
- Verify the cluster is running

### 3. Deploy Ollama

After the Kubernetes cluster is running, deploy Ollama with settings optimized for Codespaces:

```bash
./scripts/codespaces-start.sh
```

This will deploy Ollama and the WebUI with lower resource requirements appropriate for Codespaces.

If you prefer the standard deployment (requires more resources):

```bash
./scripts/start.sh
```

### 4. Access the WebUI

The web interface will be automatically available through the Codespaces port forwarding. Look for a notification about ports being forwarded, or:

1. Click on the "PORTS" tab in the bottom panel
2. Find port 8080, which should be labeled as "Ollama WebUI"
3. Click the globe icon to open the WebUI in your browser

### 5. Pull a Model and Start Using Ollama

Pull a model optimized for Codespaces:

```bash
./scripts/pull-model.sh phi3-mini
```

Alternatively, use VS Code Tasks (Terminal → Run Task → Pull Phi-3 Mini Model).

Recommended models for Codespaces (suitable for 8GB RAM):
- `phi3-mini` (3.8B parameters) - Microsoft's compact but powerful model
- `llama3` (8B parameters) - Meta's latest general purpose model 
- `mistral:7b` (7B parameters) - Excellent all-around performance
- `codellama:7b` (7B parameters) - Specialized for code generation

Avoid larger models like llama2-70b or mixtral-8x7b as they will likely crash in standard Codespaces environments.

### 6. Test API Connection

To verify that the Ollama API is working correctly:

```bash
./scripts/test-api.sh
```

This will check both the cluster service and localhost connections if port forwarding is active.

### 7. Monitor Resources

Keep an eye on resource usage:

```bash
./scripts/monitor.sh
```

## VS Code Integration

This repository includes several helpful VS Code tools:

### Using Tasks

1. Press `Ctrl+Shift+P` (or `Cmd+Shift+P` on Mac)
2. Type "Tasks: Run Task" and select it
3. Choose from available tasks:
   - Setup Kubernetes Cluster
   - Deploy Ollama (Codespaces-optimized)
   - Pull Phi-3 Mini Model
   - Pull Llama3 Model
   - Monitor Resources
   - Test Ollama API
   - And more!

### Using Launch Configurations

1. Open the "Run and Debug" view (Ctrl+Shift+D)
2. Select a configuration from the dropdown at the top
3. Click the green "Play" button

## Limitations in Codespaces

GitHub Codespaces has resource limitations to be aware of:
- Standard Codespaces have 8GB RAM, which limits you to smaller models
- Larger models may be slow or not work at all
- If you need more resources, consider upgrading your Codespace machine type by clicking the gear icon in the lower left corner and selecting a higher spec machine

## Troubleshooting

### Pod won't start in Codespaces
- Check resources: `kubectl describe pod -n ollama`
- Try a smaller model or adjust memory limits in the deployment files

### Ports not forwarding
- Run `kubectl port-forward -n ollama svc/ollama-webui 8080:8080`
- Check the "PORTS" tab to ensure port 8080 is being forwarded

### Minikube won't start
- Check Docker is running: `docker ps`
- Try restarting with lower resource limits: `minikube start --memory=4g --cpus=1`
