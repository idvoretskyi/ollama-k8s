## OOMKilled WebUI Issue - Fix Summary

We've addressed the problem with the WebUI container crashing due to an Out Of Memory (OOM) error. Here's a summary of the changes made:

### 1. Problem Diagnosis
- The WebUI container was being terminated with reason `OOMKilled` and exit code `137`
- This indicated that the container was running out of memory with the previous limit of 512Mi

### 2. Solution Applied
- Increased the memory resources for the WebUI container:
  - Requests increased from 256Mi to 512Mi
  - Limits increased from 512Mi to 1Gi
- Applied the updated configuration to the cluster

### 3. Results
- The WebUI pod is now running successfully
- No more CrashLoopBackOff or OOMKilled errors

### 4. Documentation Updates
- Updated README.md to include more accurate memory requirements
- Added a troubleshooting entry in USAGE.md for WebUI memory issues
- Fixed the port-forward.sh script to handle termination more gracefully

### 5. How to Verify
- The WebUI pod status should now show as Running: `kubectl get pods -n ollama`
- You can access the WebUI at http://172.18.0.8:8080 or via port forwarding at http://localhost:8080

If you continue to experience memory-related issues, you can further adjust the resources as needed in the webui-deployment.yaml file.
