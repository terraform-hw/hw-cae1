provider "huaweicloud" {
  project_id = "935ca239302b4794a8efbd7affc25661"
}

resource "huaweicloud_cae_component" "test" {
  environment_id = "46dc4388-0383-4f16-b5d0-81bc7e28ad93"
  application_id =  "75e7e682-d7c9-4dde-b5c4-7cd954bbdecb"

  metadata {
    name = "test01"

    annotations = {
      version = "1.0.0"
    }
  }

  spec {
    runtime = "Docker"
    replica = 1

    source {
      type = "image"
      url  = "swr.me-east-1.myhuaweicloud.com/frank/nginx:1.19"
    }

    resource_limit {
      cpu    = "500m"
      memory = "1Gi"
    }
  }
  deploy_after_create = true
}

resource "huaweicloud_cae_component_configurations" "test" {
  environment_id = "46dc4388-0383-4f16-b5d0-81bc7e28ad93"
  application_id =  "75e7e682-d7c9-4dde-b5c4-7cd954bbdecb"
  component_id   = huaweicloud_cae_component.test.id
  items {
    type = "lifecycle"
    data = jsonencode({
      "spec": {
        "postStart": {
          "exec": {
            "command": [
              "/bin/bash",
              "-c",
              "sleep",
              "10",
              "done",
            ]
          }
        }
      }
    })
  }
  items {
    type = "env"
    data = jsonencode({
      "spec": {
        "envs": {
            "key": "value",
            "foo": "bar"
        }
      }
    })
  }
}
