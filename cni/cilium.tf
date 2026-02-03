resource "helm_release" "cilium" {
  name       = "cilium"
  repository = "https://helm.cilium.io/"
  chart      = "cilium"
  version    = "1.18.3"
  namespace  = "kube-system"

  # IPAM Configuration
  set {
    name  = "ipam.mode"
    value = "kubernetes"
  }

  # Kube-proxy replacement
  set {
    name  = "kubeProxyReplacement"
    value = "true"
  }

  # Security context capabilities for ciliumAgent
  set {
    name  = "securityContext.capabilities.ciliumAgent"
    value = "{CHOWN,KILL,NET_ADMIN,NET_RAW,IPC_LOCK,SYS_ADMIN,SYS_RESOURCE,DAC_OVERRIDE,FOWNER,SETGID,SETUID}"
  }

  # Security context capabilities for cleanCiliumState
  set {
    name  = "securityContext.capabilities.cleanCiliumState"
    value = "{NET_ADMIN,SYS_ADMIN,SYS_RESOURCE}"
  }

  # Cgroup configuration for Talos
  set {
    name  = "cgroup.autoMount.enabled"
    value = "false"
  }

  set {
    name  = "cgroup.hostRoot"
    value = "/sys/fs/cgroup"
  }

  # Kubernetes API server configuration
  set {
    name  = "k8sServiceHost"
    value = "localhost"
  }

  set {
    name  = "k8sServicePort"
    value = "7445"
  }

  # Gateway API configuration
  set {
    name  = "gatewayAPI.enabled"
    value = "true"
  }

  set {
    name  = "gatewayAPI.enableAlpn"
    value = "true"
  }

  set {
    name  = "gatewayAPI.enableAppProtocol"
    value = "true"
  }

  # Operator configuration
  set {
    name  = "operator.rollOutPods"
    value = "true"
  }

  set {
    name  = "operator.replicas"
    value = "1"
  }

  # ===== HUBBLE CONFIGURATION =====

  # Enable Hubble
  set {
    name  = "hubble.enabled"
    value = "true"
  }

  # Enable Hubble Relay
  set {
    name  = "hubble.relay.enabled"
    value = "true"
  }

  # Enable Hubble UI (optional but recommended)
  set {
    name  = "hubble.ui.enabled"
    value = "true"
  }

  # Hubble metrics (optional)
  set {
    name  = "hubble.metrics.enabled"
    value = "{dns,drop,tcp,flow,port-distribution,icmp,httpV2:exemplars=true;labelsContext=source_ip,source_namespace,source_workload,destination_ip,destination_namespace,destination_workload,traffic_direction}"
  }

  # Hubble metrics server (for Prometheus scraping)
  set {
    name  = "hubble.metrics.enableOpenMetrics"
    value = "true"
  }

  # Hubble Relay replicas
  set {
    name  = "hubble.relay.replicas"
    value = "1"
  }
}

output "cilium_status" {
  value = helm_release.cilium.status
}

output "cilium_version" {
  value = helm_release.cilium.version
}
