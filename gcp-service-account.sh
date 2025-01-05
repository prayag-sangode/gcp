#!/bin/bash
#Author : Prayag Sangode
#Create a service account in GCP

#Set project-id
export GCP_PROJECT_ID="Enter GCP Project ID"
echo $GCP_PROJECT_ID

#Set Service Account Name
export SERVICE_ACCOUNT_NAME=GCP-SA
echo $SERVICE_ACCOUNT_NAME

#Enable services
gcloud services enable containerregistry.googleapis.com container.googleapis.com compute.googleapis.com storage-api.googleapis.com storage.googleapis.com

#Create Service Account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

#Assign permission to service account # gcloud iam roles list 
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/iam.securityAdmin

#gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/storage.admin
#gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/compute.admin
#gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/compute.storageAdmin
#gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/recommender.firewallAdmin
#gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/container.admin
#gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/container.clusterViewer

#gcloud iam service-accounts keys create serviceaccount.json --iam-account=$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com
gcloud iam service-accounts keys list  --iam-account=$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com

#cat serviceaccount.json | base64 -w0
#cat serviceaccount.json | tr -s '\n' ' '
echo "Service Account Name is:" $SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com
echo "GCP Project/ID is:" $GCP_PROJECT_ID

# Create and download the service account key (JSON file)
gcloud iam service-accounts keys create $SERVICE_ACCOUNT_NAME-key.json --iam-account=$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com
echo "JSON file downloaded in current directory"

