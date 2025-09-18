#!/bin/bash
set -e

# Variables
GCP_SDK_VERSION="460.0.0"
INSTALL_DIR="$HOME/google-cloud-sdk"

# Download and extract Google Cloud SDK
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCP_SDK_VERSION}-linux-x86_64.tar.gz
tar -xf google-cloud-cli-${GCP_SDK_VERSION}-linux-x86_64.tar.gz

# Install SDK
./google-cloud-sdk/install.sh --quiet

# Add gcloud to PATH
echo "source $INSTALL_DIR/path.bash.inc" >> ~/.bashrc
source ~/.bashrc

# Install kubectl component
gcloud components install kubectl --quiet

# Confirm installation
gcloud version
kubectl version --client

# After installing gcloud, authenticate using
# gcloud auth login --no-launch-browser
