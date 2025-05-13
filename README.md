# Ollama on Kubernetes

This repository contains Kubernetes manifests to deploy Ollama and Open WebUI on a Kubernetes cluster. This setup allows you to run large language models (LLMs) locally in your Kubernetes environment.

🚀 **Quick start:** Run `./scripts/quick-start.sh` to begin

[![Open in GitHub Codespaces](https://github.com/codespaces/badge.svg)](https://codespaces.new/idvoretskyi/ollama-k8s)

Try it online instantly with no local setup! [See Codespaces instructions](docs/CODESPACES.md)

📋 **Recent Improvements:** Check out our [project improvements summary](docs/IMPROVEMENTS.md) for details on recent enhancements.

## Directory Structure

This project has been organized into a tree-based layout for improved maintainability:

- `docs/` - Documentation files
- `k8s/` - Kubernetes manifests (standard and codespaces variants)
- `scripts/` - Shell scripts for various operations
- Previously had root `.sh` files for compatibility (now moved to scripts/)

## What's Included

- **Ollama**: A framework for running LLMs locally
- **Open WebUI**: A web interface for interacting with Ollama models
- **Helper Scripts**: For pulling models and port-forwarding
- **GitHub Codespaces Support**: Run everything in the cloud
- **Quick Start Script**: Simple menu to get started (`./scripts/quick-start.sh`)

## Prerequisites

- A running Kubernetes cluster (tested on local Kubernetes with 24GB RAM)
- kubectl installed and configured
- At least 8GB of RAM available for running models (more for larger models)
- About 1.5GB of RAM for the WebUI and Ollama service components

## Hardware Recommendations

- For small models (Llama3-8B, Mistral-7B, Phi3-mini): At least 8GB RAM
- For medium models (CodeLlama-7B, etc.): At least 16GB RAM
- For larger models (Llama3-70B, etc.): 24GB+ RAM (may require GPU)

## Quick Setup

Run the quick start script to deploy everything in one step:

```bash
./scripts/quick-start.sh
```

## Manual Deployment

1. Create the namespace:
   ```
   kubectl apply -f k8s/standard/namespace.yaml
   ```

2. Create the persistent volume claim:
   ```
   kubectl apply -f k8s/standard/pvc.yaml
   ```

3. Deploy Ollama:
   ```
   kubectl apply -f k8s/standard/deployment.yaml
   ```

4. Create the Ollama service:
   ```
   kubectl apply -f k8s/standard/service.yaml
   ```

5. Deploy the Web UI:
   ```
   kubectl apply -f k8s/standard/webui-deployment.yaml
   ```

6. Create the Web UI service:
   ```
   kubectl apply -f k8s/standard/webui-service.yaml
   ```

## Accessing Ollama

Once deployed, you can access Ollama API at:
```
http://<OLLAMA-EXTERNAL-IP>:11434
```

To get the external IP:
```
kubectl get svc ollama -n ollama
```

## Web UI

For a user-friendly interface, we've included the Open WebUI for Ollama.
Once deployed, you can access the UI at:
```
http://<WEBUI-EXTERNAL-IP>:8080
```

To get the WebUI external IP:
```
kubectl get svc ollama-webui -n ollama
```

### Port Forwarding

If you're running on a local Kubernetes cluster and want to access Ollama and WebUI through localhost, use the included port-forwarding script:

```bash
./scripts/port-forward.sh
```

This will make Ollama available at http://localhost:11434 and the WebUI at http://localhost:8080.

Press Ctrl+C to stop port forwarding when you're done.

## Running models

Ollama will be available at http://<OLLAMA-EXTERNAL-IP>:11434. You can interact with it using:

1. The Open WebUI (recommended)
2. The Ollama CLI (if port-forwarding)
3. REST API calls

For detailed usage instructions, examples, and performance expectations, see the [USAGE.md](docs/USAGE.md) file.

Quick example API call:
```
curl -X POST http://<OLLAMA-EXTERNAL-IP>:11434/api/generate -d '{
  "model": "llama3",
  "prompt": "Why is the sky blue?"
}'
```

## Pulling models

### Using the Helper Script

We've included a helper script to make pulling models easier:

```bash
./scripts/pull-model.sh llama3
```

You can replace `llama2` with any model available in the [Ollama Library](https://ollama.ai/library).

### Manual Method

Alternatively, you can pull a model by executing directly into the pod:
```bash
kubectl exec -it -n ollama $(kubectl get pods -n ollama -l app=ollama -o jsonpath='{.items[0].metadata.name}') -- ollama pull llama3
```

## Available Models

Here are some recommended models that work well with 8GB RAM:

- **llama3**: The latest Meta Llama 3 model (8B parameters)
- **mistral**: Mistral 7B model
- **phi3-mini**: Microsoft's Phi-3 mini model (3.8B parameters)
- **phi3**: Microsoft's Phi-3 small model (7B parameters)
- **codellama:7b**: Specialized for code generation (7B parameters)

For more information on available models, visit the [Ollama Library](https://ollama.ai/library).

## Contributing

Contributions are welcome! Here's how you can contribute to this project:

1. Fork the repository
2. Create a new branch (`git checkout -b feature/your-feature-name`)
3. Make your changes
4. Commit your changes (`git commit -m 'Add some feature'`)
5. Push to the branch (`git push origin feature/your-feature-name`)
6. Open a Pull Request

Please ensure your code follows the existing style and includes appropriate documentation.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
