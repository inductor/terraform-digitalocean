provider "digitalocean" {}

resource "digitalocean_kubernetes_cluster" "foo" {
  name   = "foo"
  region = "sgp1"
  # Grab the latest version slug from `doctl kubernetes options versions`
  version = "1.16.2-do.1"

  node_pool {
    name       = "worker-pool"
    size       = "s-2vcpu-2gb"
    node_count = 3
  }
}

provider "kubernetes" {
  host  = digitalocean_kubernetes_cluster.foo.endpoint
  token = digitalocean_kubernetes_cluster.foo.kube_config[0].token
  cluster_ca_certificate = base64decode(
    digitalocean_kubernetes_cluster.foo.kube_config[0].cluster_ca_certificate
  )
}

resource "digitalocean_domain" "default" {
  name = "inductor.dev"
}
