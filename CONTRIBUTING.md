# Contributing to Ollama Kubernetes

Thank you for your interest in contributing to this project! This document provides guidelines for contributing to the Ollama Kubernetes project.

## Code of Conduct

By participating in this project, you agree to be respectful and constructive in your communications with other contributors.

## How to Contribute

### Reporting Bugs

If you find a bug, please open an issue with the following information:
- A clear, descriptive title
- Steps to reproduce the issue
- Expected behavior
- Actual behavior
- Your environment (Kubernetes version, host OS, etc.)
- Any relevant logs or screenshots

### Feature Requests

If you have an idea for a new feature:
- Check if the feature has already been suggested in the issues
- Open a new issue with a clear description of the feature and its benefits
- If possible, include examples of how the feature would work

### Pull Requests

We welcome contributions via pull requests! Here's how to submit one:

1. Fork the repository
2. Create a new branch from `main` (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test your changes
5. Commit your changes (`git commit -m 'Add amazing feature'`)
6. Push to your branch (`git push origin feature/amazing-feature`)
7. Open a Pull Request against the `main` branch

### Pull Request Guidelines

- Update documentation for any changed functionality
- Keep each PR focused on a single change or feature
- Write clear commit messages
- Include tests if applicable
- Ensure all tests pass before submitting
- Reference any related issues in your PR description

## Project Structure

The project is organized as follows:

- `docs/` - Documentation files
- `k8s/` - Kubernetes manifests
  - `standard/` - Standard manifests
  - `codespaces/` - Codespaces-optimized manifests
- `scripts/` - Shell scripts for deployment and management
- Root `.sh` files - Wrapper scripts for backward compatibility

## Development Setup

1. Fork and clone the repository
2. Ensure you have a Kubernetes cluster available for testing (minikube, Docker Desktop, etc.)
3. Make changes and test locally
4. Submit your PR

## License

By contributing to this project, you agree that your contributions will be licensed under the project's [MIT License](LICENSE).
