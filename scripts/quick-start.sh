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
BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

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

# Function to display menu
display_menu() {
    echo -e "Please select a deployment option:"
    echo -e "  ${GREEN}1) Start Ollama (Standard)${NC} - For most environments"
    echo -e "  ${GREEN}2) Start Ollama (Codespaces)${NC} - Optimized for GitHub Codespaces"
    echo -e "  ${GREEN}3) Pull a model${NC} - Download a model from Ollama repository"
    echo -e "  ${GREEN}4) Port-forward services${NC} - Access services via localhost"
    echo -e "  ${GREEN}5) Test API connectivity${NC} - Verify API is working"
    echo -e "  ${GREEN}6) Monitor resources${NC} - View resource usage"
    echo -e "  ${GREEN}7) Exit${NC}"
    echo ""
    if [ "$RECOMMENDED" == "codespaces" ]; then
        echo -e "${YELLOW}Recommendation: Option 2 (Codespaces) is suggested for your environment${NC}"
    else
        echo -e "${YELLOW}Recommendation: Option 1 (Standard) is suggested for your environment${NC}"
    fi
}

# Function for spinner animation
spinner() {
    local pid=$1
    local delay=0.1
    local spinstr='|/-\'
    while [ "$(ps a | awk '{print $1}' | grep $pid)" ]; do
        local temp=${spinstr#?}
        printf " [%c]  " "$spinstr"
        local spinstr=$temp${spinstr%"$temp"}
        sleep $delay
        printf "\b\b\b\b\b\b"
    done
    printf "    \b\b\b\b"
}

# Main logic
while true; do
    display_menu
    echo ""
    read -p "Enter your choice [1-7]: " choice
    
    case $choice in
        1)
            echo -e "\n${GREEN}Starting Ollama with standard configuration...${NC}\n"
            "$BASE_DIR/scripts/start.sh"
            ;;
        2)
            echo -e "\n${GREEN}Starting Ollama with Codespaces configuration...${NC}\n"
            "$BASE_DIR/scripts/codespaces-start.sh"
            ;;
        3)
            echo -e "\n${GREEN}Available models:${NC} llama3, mistral, phi3-mini, phi3, codellama:7b"
            read -p "Enter model name: " model_name
            if [ -n "$model_name" ]; then
                echo -e "\n${GREEN}Pulling model $model_name...${NC}\n"
                "$BASE_DIR/scripts/pull-model.sh" "$model_name"
            else
                echo -e "\n${RED}No model specified.${NC}"
            fi
            ;;
        4)
            echo -e "\n${GREEN}Setting up port forwarding...${NC}\n"
            "$BASE_DIR/scripts/port-forward.sh"
            ;;
        5)
            echo -e "\n${GREEN}Testing API connectivity...${NC}\n"
            "$BASE_DIR/scripts/test-api.sh"
            ;;
        6)
            echo -e "\n${GREEN}Launching resource monitor...${NC}\n"
            "$BASE_DIR/scripts/monitor.sh"
            ;;
        7)
            echo -e "\n${GREEN}Exiting...${NC}\n"
            exit 0
            ;;
        *)
            echo -e "\n${RED}Invalid option. Please try again.${NC}\n"
            ;;
    esac
    
    echo ""
    read -p "Press Enter to continue..."
    clear
done
