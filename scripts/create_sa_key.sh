#!/bin/bash
set -e

# Variables
PROJECT_ID="gpc-project-101"
SA_NAME="gke-admin"
KEY_FILE="$HOME/gke-admin-key.json"

# Create service account
gcloud iam service-accounts create $SA_NAME \
  --display-name "GKE Admin Service Account" \
  --project $PROJECT_ID

# Assign roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/container.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/compute.networkAdmin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

# Create and download JSON key
gcloud iam service-accounts keys create $KEY_FILE \
  --iam-account=$SA_NAME@$PROJECT_ID.iam.gserviceaccount.com

echo "Service account key saved to $KEY_FILE"

# Activate service account
# gcloud auth activate-service-account --key-file=$KEY_FILE
# gcloud auth activate-service-account --key-file=gke-admin-key.json

# Set default project
# gcloud config set project $PROJECT_ID
# gcloud config set project gpc-project-101

