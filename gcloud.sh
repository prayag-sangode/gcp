# Remove existing Google Cloud SDK installations
sudo snap remove google-cloud-cli
sudo apt remove google-cloud-sdk -y

# Download and install the Google Cloud CLI
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-456.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-*-linux-x86_64.tar.gz
sudo mv google-cloud-sdk /opt/

# Add the Google Cloud SDK to the system-wide PATH for all users
echo 'export PATH=/opt/google-cloud-sdk/bin:$PATH' | sudo tee -a /etc/profile

# Add the GKE auth plugin environment variable globally
echo "export USE_GKE_GCLOUD_AUTH_PLUGIN=True" | sudo tee -a /etc/profile

# Install the gke-gcloud-auth-plugin without prompting
sudo gcloud components install gke-gcloud-auth-plugin --quiet

# Install kubectl
sudo gcloud components install kubectl --quiet

# Ensure changes to the profile are immediately available
source /etc/profile
