ISSUER=http://35.229.246.122:8080/
PROJECT=mypoc-374706
POOL=jenkins-oidc-pool
PROVIDER=static
SA="GCP-SA@mypoc-374706.iam.gserviceaccount.com"
gcloud iam workload-identity-pools create $POOL \
  --location=global
gcloud iam workload-identity-pools providers create-oidc $PROVIDER \
  --workload-identity-pool=$POOL \
  --issuer-uri=$ISSUER \
  --location=global \
  --attribute-mapping=google.subject=assertion.sub
gcloud iam service-accounts add-iam-policy-binding $SA \
  --role=roles/iam.workloadIdentityUser \
  --member="principalSet://iam.googleapis.com/projects/$PROJECT/locations/global/workloadIdentityPools/$POOL/*"
echo audience must be https://iam.googleapis.com/projects/$PROJECT/locations/global/workloadIdentityPools/$POOL/providers/$PROVIDER
