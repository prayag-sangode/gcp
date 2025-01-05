#!/bin/bash
# Author : Prayag Sangode
# Create a service account in GCP and download the JSON key

# Prompt user for GCP Project ID
read -p "Enter GCP Project ID: " GCP_PROJECT_ID
echo "Project ID: $GCP_PROJECT_ID"

# Set Service Account Name
export SERVICE_ACCOUNT_NAME=GCP-SA
echo "Service Account Name: $SERVICE_ACCOUNT_NAME"

# Enable services
gcloud services enable containerregistry.googleapis.com container.googleapis.com compute.googleapis.com storage-api.googleapis.com storage.googleapis.com

# Check if service account exists
if ! gcloud iam service-accounts list --filter="email:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com" --format="value(email)"; then
    # Create Service Account if it doesn't exist
    gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME
else
    echo "Service account already exists!"
fi

# Assign permissions to the service account
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/editor

# Create and download the service account key (JSON file)
gcloud iam service-accounts keys create $SERVICE_ACCOUNT_NAME-key.json --iam-account=$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com

# List service account keys
gcloud iam service-accounts keys list --iam-account=$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com

echo "Service Account Name is:" $SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com
echo "GCP Project/ID is:" $GCP_PROJECT_ID
echo "Service Account Key (JSON) downloaded as: $SERVICE_ACCOUNT_NAME-key.json"
