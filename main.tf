provider "huaweicloud" {}
variable "environment_id" {}
variable "application_id" {}
variable "component_name" {}
variable "image_url" {}

resource "huaweicloud_cae_component" "test" {
  environment_id = "46dc4388-0383-4f16-b5d0-81bc7e28ad93"
  application_id =  "75e7e682-d7c9-4dde-b5c4-7cd954bbdecb"

  metadata {
    name = var.component_name

    annotations = {
      version = "1.0.0"
    }
  }

  spec {
    runtime = "Docker"
    replica = 1

    source {
      type = "image"
      url  = "docker pull swr.me-east-1.myhuaweicloud.com/frank/nginx:1.19"
    }

    resource_limit {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
}
