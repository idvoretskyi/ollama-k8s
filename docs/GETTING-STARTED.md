# Getting Started with Your Ollama Kubernetes Setup

Congratulations! You've successfully deployed Ollama and Open WebUI to your Kubernetes cluster. Here's a quick guide to start using your setup:

## 1. Access Points

Your services are available at:
- Ollama API: http://172.18.0.7:11434
- Open WebUI: http://172.18.0.8:8080

## 2. First Steps

1. Visit the WebUI at http://172.18.0.8:8080
2. When prompted for the API endpoint, enter: `http://ollama:11434`
3. Pull a model using: `./scripts/pull-model.sh llama2` (or any other model)
4. Start chatting with your model!

## 3. Quick Start

For a simpler experience, you can use our quick start script:
```bash
./scripts/quick-start.sh
```

## 5. Monitoring Resources

Use the included monitoring script to keep an eye on resource usage:
```bash
./scripts/monitor.sh
```

## 6. Available Helper Scripts

- `./scripts/port-forward.sh`: Access services via localhost
- `./scripts/pull-model.sh`: Easily pull new models
- `./scripts/monitor.sh`: Monitor resource usage
- `./scripts/test-api.sh`: Test API connectivity

## 5. Next Steps

- Try different models based on your hardware capabilities
- Experiment with the Ollama API for programmatic access
- Check out the WebUI settings for additional configuration options

## 6. Power Management

Running LLMs can be resource-intensive. Consider:
- Scaling down when not in use: `kubectl scale deployment -n ollama ollama --replicas=0`
- Scaling back up: `kubectl scale deployment -n ollama ollama --replicas=1`

See [USAGE.md](USAGE.md) for detailed usage information.

Enjoy experimenting with your local LLM setup!
