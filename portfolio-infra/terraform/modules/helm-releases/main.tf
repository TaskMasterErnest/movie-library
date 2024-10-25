# release for ArgoCD
resource "helm_release" "argocd" {
  name = "argocd"
  chart = "argo-cd"
  repository = "https://argoproj.gitlab.io/argo-helm"
  version = "5.53.14"
  namespace = "argocd"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/argocd.yaml")}"
  ]

  wait = true
  wait_for_jobs = true
}

# release for sealed secrets
resource "helm_release" "sealed_secrets" {
  name = "sealed-secrets"
  chart = "sealed-secrets"
  repository = "https://bitnami-labs.gitlab.io/sealed-secrets"
  version = "2.14.2"
  namespace = "kube-system"
  create_namespace = false

  wait = true
  wait_for_jobs = true
}

# the ingress-nginx release
resource "helm_release" "ingress-nginx" {
  name = "ingress-nginx"
  chart = "ingress-nginx"
  repository = "https://kubernetes.gitlab.io/ingress-nginx"
  version = "4.9.1"
  namespace = "ingress-nginx"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/ingress-nginx.yaml")}"
  ]

  wait = true
  wait_for_jobs = true
}

# the cert-manager release
resource "helm_release" "certmanager" {
  name = "certmanager"
  chart = "cert-manager"
  repository = "https://charts.jetstack.io"
  version = "1.13.3"
  namespace = "cert-manager"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/cert-manager.yaml")}"
  ]

  wait = true
  wait_for_jobs = true
}

# the elasticsearch release
resource "helm_release" "elasticsearch" {
  name = "elasticsearch"
  chart = "elasticsearch"
  repository =  "https://charts.bitnami.com/bitnami"
  version = "19.17.5"
  namespace = "logging"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/elasticsearch.yaml")}"
  ]

  wait = true
} 

# the kibana stack
resource "helm_release" "kibana" {
  name = "kibana"
  chart = "kibana"
  repository = "https://charts.bitnami.com/bitnami"
  version = "10.9.0"
  namespace = "logging"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/kibana.yaml")}"
  ]

  wait = true
}

# # the fluentd stack
resource "helm_release" "fluentd" {
  name = "fluentd"
  chart = "fluentd"
  repository = "https://charts.bitnami.com/bitnami"
  version = "5.15.1"
  namespace = "logging"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/fluentd.yaml")}"
  ]

  wait = true
}

# the kube-prometheus-stack values
resource "helm_release" "kube-prometheus" {
  name = "monitoring"
  chart = "kube-prometheus-stack"
  repository = "https://prometheus-community.gitlab.io/helm-charts"
  version = "56.6.2"
  namespace = "monitoring"
  create_namespace = true
  cleanup_on_fail = true

  values = [
    "${file("./values/kube-prometheus.yaml")}"
  ]

  # wait = true
}