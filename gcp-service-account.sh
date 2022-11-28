#!/bin/bash
#Author : Prayag Sangode
#Create a service account in GCP

#Set project-id
export GCP_PROJECT_ID=$(gcloud projects list | grep -i "project_id" | awk '{print $2}')
echo $GCP_PROJECT_ID

#Set Service Account Name
export SERVICE_ACCOUNT_NAME=GCP-TF-SA
echo $SERVICE_ACCOUNT_NAME
#export SERVICE_ACCOUNT_NAME=GCP-TF-Storage-SA
#export SERVICE_ACCOUNT_NAME=GCP-TF-Compute-SA

#Enable services
gcloud services enable containerregistry.googleapis.com container.googleapis.com compute.googleapis.com storage-api.googleapis.com storage.googleapis.com

#Create Service Account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

#Assign permission to service account # gcloud iam roles list 
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/editor
gcloud projects add-iam-policy-binding $GCP_PROJECT_ID --memeber=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role/iam.securityAdmin

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
