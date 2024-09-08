provider "kubernetes" {
  config_path = "~/.kube/config"
  config_context = "docker-desktop"
}

module "simple_webapp" {
  source = "../../modules/services/k8s-app"

  name = "simple-webapp"
  image = "setsumaru1992/example-http"
  replicas = 2
  container_port = 5000
}