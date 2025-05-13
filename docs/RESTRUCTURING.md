# Directory Structure Reorganization

## Overview

This document outlines the restructuring of the Ollama Kubernetes codebase into a more organized tree-based layout. The restructuring focuses on improving maintainability, separating concerns, and making the repository easier to navigate.

## New Directory Structure

```
ollama-k8s/
├── docs/                    # All documentation files
│   ├── CODESPACES.md        # GitHub Codespaces instructions
│   ├── FIX-REPORT.md        # Troubleshooting report
│   ├── GETTING-STARTED.md   # Getting started guide
│   └── USAGE.md             # Usage instructions
├── k8s/                     # Kubernetes manifests
│   ├── codespaces/          # Codespaces-optimized manifests
│   │   ├── deployment.yaml
│   │   ├── models-pvc.yaml
│   │   └── webui-deployment.yaml
│   └── standard/            # Standard manifests for local use
│       ├── deployment.yaml
│       ├── namespace.yaml
│       ├── pvc.yaml
│       ├── service.yaml
│       ├── webui-deployment.yaml
│       └── webui-service.yaml
├── scripts/                 # All shell scripts
│   ├── codespaces-setup.sh  # Setup script for Codespaces
│   ├── codespaces-start.sh  # Start Ollama in Codespaces
│   ├── monitor.sh           # Resource monitoring script
│   ├── port-forward.sh      # Port forwarding utility
│   ├── pull-model.sh        # Model downloading utility
│   ├── start.sh             # Standard deployment script
│   ├── test-api.sh          # API testing utility
│   └── welcome.sh           # Welcome message script
├── README.md                # Main documentation
└── *.sh                     # Wrapper scripts (for backward compatibility)
```

## Changes Made

1. **Separated Documentation**:
   - Moved all documentation files to the `docs/` directory
   - Updated all references to documentation in scripts and README

2. **Organized Kubernetes Manifests**:
   - Created `k8s/standard/` for regular deployments
   - Created `k8s/codespaces/` for GitHub Codespaces optimized deployments
   - Updated all scripts to reference the new manifest locations

3. **Consolidated Scripts**:
   - Moved all shell scripts to the `scripts/` directory
   - Added `BASE_DIR` variables to make file paths relative
   - Updated path references to use the new directory structure

4. **Maintained Backward Compatibility**:
   - Created wrapper scripts in the root directory
   - These thin wrappers forward commands to the actual scripts in the `scripts/` directory

5. **Updated VS Code Tasks**:
   - Updated path references in `.vscode/tasks.json`
   - Tasks now correctly refer to scripts in the `scripts/` directory

6. **Updated GitHub Codespaces Configuration**:
   - Updated devcontainer.json to use the new script paths

## Benefits of the New Structure

1. **Better Organization**: Files are grouped by function (docs, k8s manifests, scripts)
2. **Easier Maintenance**: Changes to one component don't affect others
3. **Improved Readability**: Directory names clearly indicate contents
4. **Backward Compatibility**: Existing documentation and instructions still work
5. **Easier Extension**: New files can be added to the appropriate directory

## Next Steps

- Update README with new structure information
- Consider adding more documentation about the project structure
- Explore adding automated testing
