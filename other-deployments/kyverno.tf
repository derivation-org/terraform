# kyverno helm deployment
resource "helm_release" "kyverno" {
  name             = "kyverno"
  repository       = "https://kyverno.github.io/kyverno/"
  chart            = "kyverno"
  namespace        = "kyverno"
  create_namespace = true

  set {
    name  = "replicaCount"
    value = 2
  }

  set {
    name  = "resourceFilters"
    value = "[*/*]"
  }

  set {
    name  = "webhooks.timeoutSeconds"
    value = 30
  }

  set {
    name  = "serviceMonitor.enabled"
    value = "true"
  }
}