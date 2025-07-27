# Google Cloud CLI + GKE Setup Guide

This guide provides the Google-recommended steps to install the `gcloud` CLI (Google Cloud SDK), authenticate, install `kubectl`, and connect to a GKE (Google Kubernetes Engine) cluster.

---

## Install Google Cloud CLI (Official Method)

```bash
curl -O https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-460.0.0-linux-x86_64.tar.gz
tar -xf google-cloud-cli-460.0.0-linux-x86_64.tar.gz
./google-cloud-sdk/install.sh
````

> This installs the SDK locally under `./google-cloud-sdk`.

---

## Initialize and Authenticate

```bash
./google-cloud-sdk/bin/gcloud init
```

* Log in to your Google account.
* Set your default project and compute region/zone.

To log in without browser launch:

```bash
gcloud auth login --no-launch-browser
```

---

## Add `gcloud` to PATH Permanently

If not already configured during install:

```bash
echo 'source ~/google-cloud-sdk/path.bash.inc' >> ~/.bashrc
source ~/.bashrc
```

---

## Install `kubectl` Component

```bash
gcloud components install kubectl
```

---

## Create and Authenticate to Your GKE Cluster

### Set project

```bash
gcloud config set project fiery-plate-461110-v0
```

### Set zone
```bash
gcloud config set compute/zone us-central1-a 
```

### Create GKE

```bash
gcloud container clusters create my-cluster \
  --zone=us-central1-a \
  --num-nodes=1 \
  --project=fiery-plate-461110-v0
```

This updates your `~/.kube/config` with credentials and endpoint info.

---

## Verification

Test the connection to your GKE cluster:

```bash
kubectl get nodes
```

You should see a list of GKE cluster nodes.

---

## Optional: Clean Up

To remove the SDK (if needed):

```bash
rm -rf ~/google-cloud-sdk
rm google-cloud-cli-460.0.0-linux-x86_64.tar.gz
```

---

## References

* [GCP Official Installation Guide](https://cloud.google.com/sdk/docs/install)
* [GKE Quickstart](https://cloud.google.com/kubernetes-engine/docs/quickstarts)

```
