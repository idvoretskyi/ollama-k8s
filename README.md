# Ollam- **WebUI**: A web interface for interacting with Ollama models
- **Helper Scripts**: For pulling models and port-forwarding

## Prerequisites

- A running Kubernetes cluster (tested on local Kubernetes with 24GB RAM)
- kubectl installed and configured
- At least 8GB of RAM available for running models (more for larger models)
- About 1.5GB of RAM for the WebUI and Ollama service componentsernetes

This repository contains Kubernetes manifests to deploy Ollama and Open WebUI on a Kubernetes cluster. This setup allows you to run large language models (LLMs) locally in your Kubernetes environment.

## What's Included

- **Ollama**: A framework for running LLMs locally
- **Open WebUI**: A web interface for interacting with Ollama models
- **Helper Scripts**: For pulling models and port-forwarding

## Prerequisites

- A running Kubernetes cluster (tested on local Kubernetes with 24GB RAM)
- kubectl installed and configured
- At least 8GB of RAM available for running models (more for larger models)

## Hardware Recommendations

- For small models (Llama2-7B, Mistral-7B): At least 8GB RAM
- For medium models (CodeLlama-13B, etc.): At least 16GB RAM
- For larger models (Llama2-70B, etc.): 24GB+ RAM (may require GPU)

## Deployment

1. Create the namespace:
   ```
   kubectl apply -f namespace.yaml
   ```

2. Create the persistent volume claim:
   ```
   kubectl apply -f pvc.yaml
   ```

3. Deploy Ollama:
   ```
   kubectl apply -f deployment.yaml
   ```

4. Create the Ollama service:
   ```
   kubectl apply -f service.yaml
   ```

5. Deploy the Web UI:
   ```
   kubectl apply -f webui-deployment.yaml
   ```

6. Create the Web UI service:
   ```
   kubectl apply -f webui-service.yaml
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
./port-forward.sh
```

This will make Ollama available at http://localhost:11434 and the WebUI at http://localhost:8080.

Press Ctrl+C to stop port forwarding when you're done.

## Running models

Ollama will be available at http://<OLLAMA-EXTERNAL-IP>:11434. You can interact with it using:

1. The Open WebUI (recommended)
2. The Ollama CLI (if port-forwarding)
3. REST API calls

For detailed usage instructions, examples, and performance expectations, see the [USAGE.md](USAGE.md) file.

Quick example API call:
```
curl -X POST http://<OLLAMA-EXTERNAL-IP>:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Why is the sky blue?"
}'
```

## Pulling models

### Using the Helper Script

We've included a helper script to make pulling models easier:

```bash
./pull-model.sh llama2
```

You can replace `llama2` with any model available in the [Ollama Library](https://ollama.ai/library).

### Manual Method

Alternatively, you can pull a model by executing directly into the pod:
```bash
kubectl exec -it -n ollama $(kubectl get pods -n ollama -l app=ollama -o jsonpath='{.items[0].metadata.name}') -- ollama pull llama2
```

## Available Models

Here are some popular models you can try:

- **llama2**: The Meta Llama 2 model (7B parameters)
- **mistral**: Mistral 7B model
- **mixtral**: Mixtral 8x7B (Multi-expert model)
- **phi2**: Microsoft's Phi-2 model (small but capable)
- **llama2-uncensored**: Less restricted version of Llama 2
- **codellama**: Specialized for code generation
- **stablelm-zephyr**: Lightweight and efficient model

For more information on available models, visit the [Ollama Library](https://ollama.ai/library).
