# Homelab v2 – Talos Kubernetes Cluster

This repository contains the Infrastructure as Code (IaC) used to deploy a Kubernetes cluster based on Talos Linux, fully automated using Terraform.

## Overview

- **Virtualization**: VMware ESXi
- **Operating System**: Talos Linux
- **Kubernetes**: Talos-managed Kubernetes
- **CNI**: Cilium
- **GitOps**: Flux CD
- **Provisioning & Bootstrap**: Terraform
- **Initial Node Boot**: PXE using `siderolabs/booter`

The entire lifecycle — from VM creation to Talos bootstrap, CNI installation, and GitOps setup — is managed declaratively through Terraform with no manual cluster setup steps.

## Repository Structure

```
.
├── esxi-vms/    # VMware ESXi VM provisioning
├── bootstrap/   # Talos cluster bootstrap and configuration
├── cni/         # Cilium CNI deployment
├── flux/        # Flux CD GitOps operator deployment
├── clusters/    # Flux-managed cluster configurations
│   └── dev/     # Development cluster manifests
└── admin/       # Local-only access files (excluded from Git)
```

## Objectives

- Fully reproducible Kubernetes cluster
- End-to-end automation using Terraform
- Secure handling of credentials and state
- Designed for homelab experimentation and learning

## Prerequisites

- VMware ESXi 7.0+ with network access
- Terraform 1.0+
- `talosctl` CLI installed
- `kubectl` CLI installed
- `flux` CLI installed
- PXE boot environment configured with `siderolabs/booter`

## Getting Started

### 1. Clone the Repository

```bash
git clone <repo-url>
cd homelab-v2
```

### 2. Configure Variables

Create a `terraform.tfvars` file in each Terraform directory or set environment variables for sensitive data:

```bash
export TF_VAR_esxi_hostname="your-esxi-host"
export TF_VAR_esxi_username="root"
export TF_VAR_esxi_password="your-password"
```

### 3. Deploy Infrastructure

#### Step 1: Provision ESXi VMs

```bash
cd esxi-vms
terraform init
terraform plan
terraform apply
```

#### Step 2: Bootstrap Talos Cluster

```bash
cd ../bootstrap
terraform init
terraform plan
terraform apply
```

#### Step 3: Deploy Cilium CNI

```bash
cd ../cni
terraform init
terraform plan
terraform apply
```

#### Step 4: Install Flux GitOps

```bash
cd ../flux
terraform init
terraform plan
terraform apply
```

### 4. Access Your Cluster

After deployment, retrieve your kubeconfig:

```bash
cd ../bootstrap
terraform output -raw kubeconfig > ~/.kube/config
kubectl get nodes
```

### 5. Manage Applications with Flux

Once Flux is installed, you can manage your applications through Git:

```bash
# Check Flux status
flux check

# View all Flux resources
flux get all

# Verify reconciliation
flux get kustomizations
```

Add your application manifests to the `clusters/dev/` directory and commit them to Git. Flux will automatically detect and apply the changes to your cluster.

## Key Features

- **Declarative Infrastructure**: All resources defined as code
- **Immutable OS**: Talos Linux provides a secure, minimal, and API-driven OS
- **Automated Bootstrap**: No manual `talosctl` commands required
- **GitOps with Flux**: Continuous deployment and reconciliation of cluster state
- **GitOps Ready**: Manage your applications and infrastructure through Git

## Security Notes

- The `admin/` directory contains sensitive files (kubeconfig, talosconfig) and is excluded from version control
- Always use encrypted state backends (e.g., S3 with encryption, Terraform Cloud)
- Rotate credentials regularly and use secrets management solutions

## Troubleshooting

### VMs not booting via PXE
- Verify `siderolabs/booter` is running and accessible
- Check DHCP/TFTP configuration
- Ensure network boot is enabled in VM settings

### Talos bootstrap fails
- Verify network connectivity between Terraform host and Talos nodes
- Check Talos configuration with `talosctl validate --config <config-file>`

### CNI not deploying
- Ensure Talos cluster is healthy: `kubectl get nodes`
- Check Cilium logs: `kubectl -n kube-system logs -l app.kubernetes.io/name=cilium`

### Flux not reconciling
- Check Flux components: `kubectl get pods -n flux-system`
- View reconciliation status: `flux get all`
- Check source sync: `flux get sources git`
- Review Flux logs: `kubectl -n flux-system logs -l app=source-controller`


## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Talos Linux](https://www.talos.dev/) - Secure Kubernetes OS
- [Cilium](https://cilium.io/) - eBPF-based CNI
- [Flux CD](https://fluxcd.io/) - GitOps toolkit for Kubernetes
- [Siderolabs](https://www.siderolabs.com/) - PXE booter and Talos tooling

---

**Happy homelabbing! 🚀**
