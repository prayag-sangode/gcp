#!/bin/bash

# Define the version and URL of Google Cloud CLI
GCLD_VERSION="411.0.0"
GCLD_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-${GCLD_VERSION}-linux-x86_64.tar.gz"

# Step 1: Download the Google Cloud CLI tarball
echo "Downloading Google Cloud CLI version ${GCLD_VERSION}..."
curl -LO $GCLD_URL

# Step 2: Extract the tarball
echo "Extracting Google Cloud CLI..."
tar zxvf google-cloud-cli-${GCLD_VERSION}-linux-x86_64.tar.gz

# Step 3: Move the extracted files to /usr/local/bin
echo "Moving Google Cloud CLI to /usr/local/bin..."
sudo mv google-cloud-sdk /usr/local/bin/

# Step 4: Add the Google Cloud SDK to PATH by modifying ~/.bashrc
echo "source /usr/local/bin/google-cloud-sdk/path.bash.inc" >> ~/.bashrc

# Step 5: Reload the shell profile to apply the changes
echo "Reloading shell profile..."
source ~/.bashrc

# Step 6: Verify if gcloud command is available
echo "Verifying installation..."
which gcloud

# Step 7: Initialize gcloud CLI
echo "Google Cloud SDK installation complete. Please run 'gcloud init' to complete the setup."
