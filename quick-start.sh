#!/bin/bash

# One-click startup script for Ollama Kubernetes
# This script provides a simple menu to select deployment options

# ANSI color codes
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Define base directory
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

clear
echo -e "${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║                                                                ║${NC}"
echo -e "${BLUE}║  ${GREEN}Ollama Kubernetes Quick Launch${BLUE}                             ║${NC}"
echo -e "${BLUE}║                                                                ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}"
echo ""

# Check if running in Codespaces
if [ -n "$CODESPACES" ]; then
    echo -e "${YELLOW}GitHub Codespaces environment detected${NC}"
    RECOMMENDED="codespaces"
else
    echo -e "${YELLOW}Local environment detected${NC}"
    RECOMMENDED="standard"
fi

echo -e "\n${GREEN}Select a deployment option:${NC}"
echo "1) Standard deployment (for local Kubernetes with 16GB+ RAM)"
echo "2) Codespaces-optimized deployment (for limited resources/cloud)"
echo "3) Help & Information"
echo "4) Exit"
echo ""
echo -e "Recommendation based on your environment: ${YELLOW}$RECOMMENDED${NC}"

read -p "Enter your choice (1-4): " choice

case $choice in
    1)
        echo -e "\n${GREEN}Starting standard deployment...${NC}"
        $BASE_DIR/scripts/start.sh
        ;;
    2)
        echo -e "\n${GREEN}Starting Codespaces-optimized deployment...${NC}"
        if [ -z "$CODESPACES" ]; then
            echo -e "${YELLOW}Note: You're not in GitHub Codespaces but using the Codespaces configuration.${NC}"
            echo -e "This configuration uses lower resource limits which might affect model performance."
            read -p "Continue? (y/n): " confirm
            if [[ $confirm != "y" ]]; then
                echo "Operation cancelled."
                exit 0
            fi
        fi
        $BASE_DIR/scripts/codespaces-start.sh
        ;;
    3)
        echo -e "\n${GREEN}Ollama Kubernetes Help${NC}"
        echo -e "${YELLOW}Documentation:${NC}"
        echo "- README.md: Main documentation"
        echo "- docs/GETTING-STARTED.md: Detailed setup instructions"
        echo "- docs/USAGE.md: Usage examples and API information"
        echo "- docs/CODESPACES.md: GitHub Codespaces instructions"
        echo ""
        echo -e "${YELLOW}Available commands:${NC}"
        echo "- scripts/start.sh: Standard deployment"
        echo "- scripts/codespaces-start.sh: Codespaces-optimized deployment"
        echo "- scripts/pull-model.sh: Download a model (e.g., llama2, phi2)"
        echo "- scripts/monitor.sh: Monitor resource usage"
        echo "- scripts/port-forward.sh: Set up port forwarding"
        echo "- scripts/test-api.sh: Test the Ollama API connection"
        echo ""
        ;;
    4)
        echo "Exiting..."
        exit 0
        ;;
    *)
        echo -e "${RED}Invalid choice. Please run again and select a valid option.${NC}"
        exit 1
        ;;
esac
