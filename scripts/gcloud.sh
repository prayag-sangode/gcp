prayag_sangode@devops-vm:~$ cat gcloud.sh 
#!/bin/bash
set -e

SDK_DIR="$HOME/google-cloud-sdk"
SDK_TAR="google-cloud-sdk-460.0.0-linux-x86_64.tar.gz"
SDK_URL="https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/${SDK_TAR}"

# Step 1: Remove Snap-managed gcloud if present
if snap list 2>/dev/null | grep -q "google-cloud-cli"; then
  echo "Removing Snap-managed gcloud..."
  sudo snap remove google-cloud-cli
else
  echo "Snap gcloud not installed, skipping..."
fi

# Step 2: Download SDK if not already present
if [ ! -f "$SDK_TAR" ]; then
  echo "Downloading Google Cloud SDK..."
  curl -O "$SDK_URL"
else
  echo "SDK tarball already exists, skipping download..."
fi

# Step 3: Extract SDK if not already extracted
if [ ! -d "$SDK_DIR" ]; then
  echo "Extracting SDK..."
  tar -xvf "$SDK_TAR"
else
  echo "SDK directory already exists, skipping extraction..."
fi

# Step 4: Install SDK if not already installed
if [ -x "$SDK_DIR/bin/gcloud" ]; then
  echo "SDK already installed, skipping install..."
else
  echo "Installing SDK..."
  "$SDK_DIR/install.sh" --quiet
fi

# Step 5: Ensure PATH and completion are sourced in future shells
if ! grep -q "google-cloud-sdk/path.bash.inc" ~/.bashrc; then
  echo "Adding SDK path to ~/.bashrc..."
  echo "source $SDK_DIR/path.bash.inc" >> ~/.bashrc
fi

if ! grep -q "google-cloud-sdk/completion.bash.inc" ~/.bashrc; then
  echo "Adding SDK completion to ~/.bashrc..."
  echo "source $SDK_DIR/completion.bash.inc" >> ~/.bashrc
fi

# Step 6: Source SDK for current shell (critical for script execution)
source "$SDK_DIR/path.bash.inc"
source "$SDK_DIR/completion.bash.inc"

# Step 7: Initialize gcloud if not already configured
if ! gcloud config list 2>/dev/null | grep -q "project"; then
  echo "Initializing gcloud..."
  gcloud init
else
  echo "gcloud already initialized, skipping..."
fi

# Step 8: Install kubectl if not already installed
if ! gcloud components list | grep -q "kubectl.*Installed"; then
  echo "Installing kubectl..."
  gcloud components install kubectl --quiet
else
  echo "kubectl already installed, skipping..."
fi

# Step 9: Verify installation
echo "Verifying installation..."
gcloud version
kubectl version --client || echo "kubectl not found in PATH"
prayag_sangode@devops-vm:~$ 
