#!/bin/bash

# This script runs during Codespace initialization, after the container is built
# but before VS Code attaches to it. It's useful for checking initialization status
# and debugging startup issues.

echo "=== Ollama K8s Codespace Initialization ==="
echo "Date: $(date)"

echo ""
echo "=== System Information ==="
cat /etc/os-release
echo ""
echo "Memory:"
free -h
echo ""
echo "CPU:"
nproc

echo ""
echo "=== Tool Versions ==="
errors=0

# Function to check if a tool is installed properly
check_tool() {
  local tool_name="$1"
  local command="$2"
  
  echo -n "${tool_name}: "
  if eval "${command}" > /dev/null 2>&1; then
    echo "$(eval "${command}")"
  else
    echo "NOT INSTALLED PROPERLY"
    errors=$((errors+1))
  fi
}

# Check all required tools
check_tool "Docker" "docker --version"
check_tool "Minikube" "minikube version --short"
check_tool "kubectl" "kubectl version --client --short 2>/dev/null"
check_tool "Helm" "helm version --short"
check_tool "kustomize" "kustomize version --short"
check_tool "GitHub CLI" "gh --version | head -n 1"

echo ""
echo "=== Initialization complete ==="
if [ $errors -gt 0 ]; then
  echo "WARNING: $errors tool(s) not installed properly. This might affect the functionality."
  echo "Check the logs above for more details."
else
  echo "All tools are properly installed."
fi
