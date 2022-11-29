export GCP_PROJECT_ID=$(gcloud projects list | grep -i "project_id" | awk '{print $2}')
echo $GCP_PROJECT_ID

export PROVIDER="gitlab-oidc-provider1"
echo $PROVIDER

export POOL="gitlab-oidc-pool1"
echo $POOL

export ISSUER=https://gitlab.com
echo $ISSUER

export SERVICE_ACCOUNT_EMAIL="GCP-TF-SA@gcp-cloud-devops-368909.iam.gserviceaccount.com"
echo $SERVICE_ACCOUNT_EMAIL

export REPO="prayag-sangode/gcp-tf.git"
echo $REPO

gcloud config set project $GCP_PROJECT_ID

gcloud iam workload-identity-pools create $POOL --project="$GCP_PROJECT_ID" --location="global" 

gcloud iam workload-identity-pools list --project="$GCP_PROJECT_ID" --location="global"

gcloud iam workload-identity-pools describe $POOL --location=global

gcloud iam workload-identity-pools providers create-oidc $PROVIDER \
--project="$GCP_PROJECT_ID" \
--location="global" \
--workload-identity-pool=$POOL \
--attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.project_path=assertion.project_path" \
--issuer-uri="$ISSUER" \
--allowed-audiences="$ISSUER"

gcloud iam workload-identity-pools describe $POOL \
--project="$GCP_PROJECT_ID" \
--location="global" \
--format="value(name)"

export WORKLOAD_IDENTITY_POOL_ID=$(gcloud iam workload-identity-pools describe $POOL --project="$GCP_PROJECT_ID" --location="global" --format="value(name)")
echo $WORKLOAD_IDENTITY_POOL_ID

gcloud iam service-accounts add-iam-policy-binding "$SERVICE_ACCOUNT_EMAIL" --project="$GCP_PROJECT_ID" --role="roles/iam.workloadIdentityUser" --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.project_path/${REPO}"

gcloud iam workload-identity-pools providers describe $PROVIDER --project=$GCP_PROJECT_ID --location="global" --workload-identity-pool=$POOL --format="value(name)"

export  GOOGLE_APPLICATION_CREDENTIALS=.gcp_temp_cred.json
