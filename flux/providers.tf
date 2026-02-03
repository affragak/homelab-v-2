terraform {
  required_providers {
    github = {
      source  = "integrations/github"
      version = "~> 6.0"
    }
    flux = {
      source  = "fluxcd/flux"
      version = "~> 1.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.25"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "github" {
  token = var.github_token
  owner = var.github_owner
}

provider "flux" {
  kubernetes = {
    config_path = "/workspaces/homelab-v-2/admin/kubeconfig"
  }
  git = {
    url = "ssh://git@github.com/${var.github_owner}/${var.github_repository}.git"
    ssh = {
      username    = "git"
      private_key = tls_private_key.flux.private_key_pem
    }
    branch = var.branch # Branch is specified here in the provider
  }
}

provider "kubernetes" {
  config_path = "/workspaces/homelab-v-2/admin/kubeconfig"
}
