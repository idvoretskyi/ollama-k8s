## Usage Examples

### Chat in Web UI

The simplest way to interact with models is through the WebUI:

1. Access the WebUI at http://localhost:8080 (if port-forwarded) or http://<WEBUI-EXTERNAL-IP>:8080
2. When prompted, configure the API endpoint to be http://ollama:11434 (or http://localhost:11434 if accessing from outside the cluster)
3. Select a model (you may need to pull it first using the pull-model.sh script)
4. Start chatting!

### API Usage

You can interact with the Ollama API directly:

```bash
# Generate a response
curl -X POST http://<OLLAMA-EXTERNAL-IP>:11434/api/generate -d '{
  "model": "llama2",
  "prompt": "Write a haiku about Kubernetes"
}'

# List available models
curl http://<OLLAMA-EXTERNAL-IP>:11434/api/tags
```

### Performance Expectations

Performance will vary depending on your hardware:

- **Mac M4 Pro (24GB)**: Should handle 7B models smoothly. 13B models may have slower response times but should work. Larger models may struggle.
- **Response times**: Expect 1-5 seconds per response with a 7B model, and 3-15 seconds with a 13B model.
- **Memory usage**: Monitor your cluster's resource usage with:
  ```bash
  kubectl top pods -n ollama
  ```

## Troubleshooting

### Pod won't start / Container creating takes too long
- Check if you have enough resources: `kubectl describe pod -n ollama`
- The Ollama image is quite large and may take time to download initially

### Model runs out of memory
- Use a smaller model (llama2 instead of llama2-13b)
- Increase the memory limit in the deployment.yaml file
- Consider enabling swap space if your system supports it

### WebUI can't connect to Ollama
- Make sure both pods are running: `kubectl get pods -n ollama`
- Check that the OLLAMA_API_BASE_URL environment variable is correctly set to "http://ollama:11434"
- Check service discovery: `kubectl exec -it -n ollama <webui-pod> -- curl ollama:11434/api/version`

### WebUI crashes with CrashLoopBackOff or OOMKilled
- The WebUI may be running out of memory. Check the logs: `kubectl logs -n ollama deployment/ollama-webui`
- If the error shows "OOMKilled" or exit code 137, increase the memory in webui-deployment.yaml:
  ```yaml
  resources:
    requests:
      memory: "512Mi"
    limits:
      memory: "1Gi"
  ```
- Apply the changes: `kubectl apply -f webui-deployment.yaml`
