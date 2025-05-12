#!/bin/bash

# Welcome script for GitHub Codespaces users
# This will be run whenever a user opens the repo in Codespaces

# Define paths
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

clear
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                ║${NC}"
echo -e "${BLUE}║  ${GREEN}Welcome to Ollama Kubernetes${BLUE}                                 ║${NC}"
echo -e "${BLUE}║                                                                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""
echo -e "${GREEN}This repository helps you run LLMs in Kubernetes using Ollama.${NC}"
echo -e "${YELLOW}This is an open source project. Contributions are welcome!${NC}"
echo ""
echo -e "${YELLOW}Getting Started in Codespaces:${NC}"
echo ""
echo -e "1. ${GREEN}Set up Kubernetes:${NC}"
echo "   $BASE_DIR/scripts/codespaces-setup.sh"
echo ""
echo -e "2. ${GREEN}Deploy Ollama (optimized for Codespaces):${NC}"
echo "   $BASE_DIR/scripts/codespaces-start.sh"
echo ""
echo -e "3. ${GREEN}Pull a small model suitable for Codespaces:${NC}"
echo "   $BASE_DIR/scripts/pull-model.sh phi2"
echo ""
echo -e "4. ${GREEN}Start chatting:${NC}"
echo "   - Find port 8080 in the PORTS tab below"
echo "   - Click the globe icon to open the WebUI"
echo "   - Set API endpoint to http://ollama:11434"
echo ""
echo -e "${YELLOW}Helpful Commands:${NC}"
echo ""
echo -e "* ${GREEN}Monitor resources:${NC} $BASE_DIR/scripts/monitor.sh"
echo -e "* ${GREEN}Port forwarding:${NC} $BASE_DIR/scripts/port-forward.sh"
echo -e "* ${GREEN}Test API connection:${NC} $BASE_DIR/scripts/test-api.sh"
echo -e "* ${GREEN}View documentation:${NC} Open $BASE_DIR/docs/CODESPACES.md"
echo ""
echo -e "${BLUE}You can also run tasks from the Terminal menu -> Run Task...${NC}"
echo ""
echo -e "${YELLOW}For more information, see $BASE_DIR/docs/CODESPACES.md and $BASE_DIR/README.md${NC}"
echo ""
echo -e "${GREEN}👉 Want to contribute? See $BASE_DIR/CONTRIBUTING.md${NC}"
echo ""
