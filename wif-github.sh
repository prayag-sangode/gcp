#https://cloud.google.com/blog/products/identity-security/enabling-keyless-authentication-from-github-actions
#https://cloud.google.com/blog/products/identity-security/enable-keyless-access-to-gcp-with-workload-identity-federation
#With Workload Identity Federation
#Create a Google Cloud service account and grant IAM permissions
#Create and configure a Workload Identity Provider for GitHub
#Exchange the GitHub Actions OIDC token for a short-lived Google Cloud access token

#GCP-SA@pune-powerhouse.iam.gserviceaccount.com

export GITREPO="prayag-sangode/gcp-infra"
echo $GITREPO

export GCP_PROJECT_ID="pune-powerhouse"
echo $GCP_PROJECT_ID

export SERVICE_ACCOUNT_NAME="GCP-SA"
echo $SERVICE_ACCOUNT_NAME

export WIF_POOL="github-oidc-pool"
echo $WIF_POOL

export WIF_POOL_DISPLAY_NAME="github-oidc-pool"
echo $WIF_POOL_DISPLAY_NAME

export WIF_PROVIDER="action"
echo $WIF_PROVIDER

gcloud iam workload-identity-pools create "${WIF_POOL}" \
  --project="${GCP_PROJECT_ID}" \
  --location="global" \
  --display-name="${WIF_POOL_DISPLAY_NAME}"

gcloud iam workload-identity-pools providers create-oidc "${WIF_PROVIDER}" \
  --project="${GCP_PROJECT_ID}" \
  --location="global" \
  --workload-identity-pool="${WIF_POOL}" \
  --display-name="${WIF_POOL_DISPLAY_NAME}" \
  --attribute-mapping="google.subject=assertion.sub,attribute.actor=assertion.actor,attribute.aud=assertion.aud" \
  --issuer-uri="https://token.actions.githubusercontent.com"

gcloud iam workload-identity-pools describe "${WIF_POOL}" \
--project="${GCP_PROJECT_ID}" \
--location="global" \
--format="value(name)"

export WORKLOAD_IDENTITY_POOL_ID="projects/264743567458/locations/global/workloadIdentityPools/github-oidc-pool"
echo $WORKLOAD_IDENTITY_POOL_ID

gcloud iam service-accounts add-iam-policy-binding "${SERVICE_ACCOUNT_NAME}@${GCP_PROJECT_ID}.iam.gserviceaccount.com" \
  --project="${GCP_PROJECT_ID}" \
  --role="roles/iam.workloadIdentityUser" \
  --member="principalSet://iam.googleapis.com/${WORKLOAD_IDENTITY_POOL_ID}/attribute.repository/${GITREPO}"

export GITHUB_WIF="$WORKLOAD_IDENTITY_POOL_ID/providers/$WIF_PROVIDER"
echo $GITHUB_WIF

#projects/264743567458/locations/global/workloadIdentityPools/github-oidc-pool/providers/action
#In github actions -

workload_identity_provider: '$WORKLOAD_IDENTITY_POOL_ID/providers/$WIF_PROVIDER' 
#workload_identity_provider: projects/264743567458/locations/global/workloadIdentityPools/github-oidc-pool/providers/action


