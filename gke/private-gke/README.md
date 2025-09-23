# Zonal Private GKE Cluster with Bastion Host

### Enable Required APIs

```bash
gcloud services enable compute.googleapis.com container.googleapis.com \
  --project=gpc-project-101
```
### Create Custom VPC & Subnets

```bash
# Create VPC
gcloud compute networks create my-vpc \
  --subnet-mode=custom \
  --project=gpc-project-101

# Public subnet (for bastion)
gcloud compute networks subnets create public-subnet \
  --network=my-vpc \
  --region=us-central1 \
  --range=10.0.1.0/24 \
  --project=gpc-project-101

# Private subnet (for GKE nodes)
gcloud compute networks subnets create private-subnet \
  --network=my-vpc \
  --region=us-central1 \
  --range=10.0.2.0/24 \
  --project=gpc-project-101
```

### Firewall Rules

```bash
# Allow SSH to bastion from your workstation IP
gcloud compute firewall-rules create allow-ssh-to-bastion \
  --network=my-vpc \
  --allow=tcp:22 \
  --source-ranges=<YOUR_PUBLIC_IP>/32 \
  --target-tags=bastion \
  --project=gpc-project-101
```

### Create Bastion VM

```bash
gcloud compute instances create bastion-vm \
  --zone=us-central1-a \
  --machine-type=e2-medium \
  --subnet=public-subnet \
  --tags=bastion \
  --image-family=debian-11 \
  --image-project=debian-cloud \
  --boot-disk-size=20GB \
  --boot-disk-type=pd-standard \
  --project=gpc-project-101
```

### Create Zonal Private GKE Cluster

```bash
gcloud container clusters create private-gke-cluster \
  --zone=us-central1-a \
  --network=my-vpc \
  --subnetwork=private-subnet \
  --enable-private-nodes \
  --enable-private-endpoint \
  --master-ipv4-cidr=172.16.0.0/28 \
  --enable-ip-alias \
  --release-channel=regular \
  --num-nodes=3 \
  --machine-type=e2-medium \
  --disk-type=pd-standard \
  --disk-size=30 \
  --enable-master-authorized-networks \
  --master-authorized-networks=10.0.1.0/24 \
  --project=gpc-project-101
```

> 3 worker nodes in **private subnet** (`10.0.2.0/24`), **1 zone (us-central1-a)**, each node **e2-medium + 30GB pd-standard disk**.
> Bastion subnet (`10.0.1.0/24`) is authorized to access the master.

### Access Cluster from Bastion

SSH into bastion:

```bash
gcloud compute ssh bastion-vm --zone=us-central1-a --project=gpc-project-101
```

### Install gcloud and kubectl on bastion host using script:

```bash
wget https://raw.githubusercontent.com/prayag-sangode/gcp/refs/heads/main/scripts/install_gcloud_kubectl.sh
bash install_gcloud_kubectl.sh
```
### Authneticate gcloud
```bash
gcloud auth login --no-launch-browser
```
or 

### Get gke-admin-key.json using script
Run script on a system which already has gcloud installed and is already authenticated and copy install_gcloud_kubectl.sh to bastion host

```bash
wget https://github.com/prayag-sangode/gcp/blob/main/scripts/create_sa_key.sh
bash create_sa_key.sh
```

### After installing gcloud, authenticate using :

```bash
gcloud auth activate-service-account --key-file=gke-admin-key.json
```

### Get cluster credentials:

```bash
gcloud container clusters get-credentials private-gke-cluster \
  --zone=us-central1-a \
  --project=gpc-project-101
```

### Test:

```bash
kubectl get nodes
```

Should show 3 nodes ready.


### Cleanup

```bash
# Delete cluster
gcloud container clusters delete private-gke-cluster \
  --zone=us-central1-a --quiet --project=gpc-project-101

# Delete bastion
gcloud compute instances delete bastion-vm \
  --zone=us-central1-a --quiet --project=gpc-project-101

# Delete firewall
gcloud compute firewall-rules delete allow-ssh-to-bastion \
  --quiet --project=gpc-project-101

# Delete subnets & VPC
gcloud compute networks subnets delete public-subnet \
  --region=us-central1 --quiet --project=gpc-project-101

gcloud compute networks subnets delete private-subnet \
  --region=us-central1 --quiet --project=gpc-project-101

gcloud compute networks delete my-vpc --quiet --project=gpc-project-101
```


```
                          ┌───────────────────────────────┐
                          │  GCP Project: gpc-project-101 │
                          └───────────────────────────────┘
                                       │
                              ┌────────┴─────────┐
                              │    VPC: my-vpc   │
                              └────────┬─────────┘
                                       │
        ┌──────────────────────────────┴─────────────────────────────┐
        │                                                            │
┌────────────────────┐                                    ┌────────────────────┐
│ Public Subnet      │ 10.0.1.0/24                        │ Private Subnet     │ 10.0.2.0/24
└─────────┬──────────┘                                     ─────────┬──────────┘
          │                                                          │
┌─────────┴─────────┐                                     ┌──────────┴───────────┐
│ Bastion VM        │                                    │ GKE Worker Nodes (x3)│
│ (10.0.1.2, public)│                                    │ e2-medium, 30GB      │
│ e2-medium, 20GB   │                                    │ Private Only         │
└─────────┬─────────┘                                     └──────────┬───────────┘
          │ SSH + kubectl                                            │
          ▼                                                          ▼
                         ┌───────────────────────────────┐
                         │ GKE Control Plane (Zonal)     │
                         │ Private Endpoint: 172.16.0.2  │
                         └───────────────────────────────┘
```

---

