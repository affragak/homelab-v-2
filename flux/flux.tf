# Variables
variable "github_token" {
  description = "GitHub Personal Access Token"
  type        = string
  sensitive   = true
}

variable "github_owner" {
  description = "GitHub owner (username or organization)"
  type        = string
}

variable "github_repository" {
  description = "GitHub repository name for Flux"
  type        = string
  default     = "homelab-v-2"
}

variable "target_path" {
  description = "Path in repository for cluster manifests"
  type        = string
  default     = "clusters/dev"
}

variable "branch" {
  description = "Git branch"
  type        = string
  default     = "main"
}

# Generate SSH key pair for Flux
resource "tls_private_key" "flux" {
  algorithm   = "ECDSA"
  ecdsa_curve = "P256"
}

# Add deploy key to GitHub repository
resource "github_repository_deploy_key" "flux" {
  title      = "Flux Deploy Key"
  repository = var.github_repository
  key        = tls_private_key.flux.public_key_openssh
  read_only  = false
}

# Bootstrap Flux
resource "flux_bootstrap_git" "this" {
  depends_on = [github_repository_deploy_key.flux]

  path = var.target_path
}

# Outputs
output "repository_url" {
  value = "https://github.com/${var.github_owner}/${var.github_repository}"
}

output "flux_deploy_key" {
  value     = tls_private_key.flux.public_key_openssh
  sensitive = true
}

output "flux_namespace" {
  value = "flux-system"
}

output "repository_path" {
  value = var.target_path
}
