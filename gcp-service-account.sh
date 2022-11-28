#!/bin/bash
# Author : Prayag Sangode
#Create a service account in GCP

#Set project-id
export GCP_PROJECT_ID=$(gcloud projects list | grep -i "project_id" | awk '{print $2}'
echo $GCP_PROJECT_ID

#Set Service Account Name
export SERVICE_ACCOUNT_NAME=GCP-TF-SA
#export SERVICE_ACCOUNT_NAME=GCP-TF-Storage-SA
#export SERVICE_ACCOUNT_NAME=GCP-TF-Compute-SA

#Create Service Account
gcloud iam service-accounts create $SERVICE_ACCOUNT_NAME

#Assign permission to service account
gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/editor

#gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/storage.admin
#gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/compute.admin
#gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/compute.storageAdmin
#gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/recommender.firewallAdmin
#gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/container.admin
#gcloud projects add-iam-policy-binding $GCP_PROJECT --member=serviceAccount:$SERVICE_ACCOUNT_NAME@$GCP_PROJECT_ID.iam.gserviceaccount.com --role=roles/container.clusterViewer
