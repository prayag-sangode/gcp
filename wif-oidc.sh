#!/bin/bash
#Author: Prayag Sangode
#WorkLoad Identity Federation - Jenkins

ISSUER=https://jenkins/oidc
POOL=jenkins-wif
PROVIDER=jenkins
PROJECT=
SA=
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

#WorkLoad Identity Federation - GitLab

ISSUER=https://gitlab.com
POOL=gitlab-wif
PROVIDER=gitlab
PROJECT=
SA=
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
