provider "huaweicloud" {
  project_id = "935ca239302b4794a8efbd7affc25661"
}
locals {
  com1_configurations = [
    {
      type = "env"
      data = jsonencode({
        "spec" : {
          "envs" : {
            "key1" : "value1",
            "key2" : "value2"
          }
        }
      })
    },
    {
      type = "access"
      data = jsonencode({
        "spec" : {
          "items" : [
            {
              "type" : "ClusterIP",
              "ports" : [
                {
                  "target_port" : 80,
                  "port" : 8001,
                  "protocol" : "TCP"
                }
              ],
            },
            {
              "type" : "LoadBalancer",
              "metadata" : {
                "annotations" : {
                  "kubernetes.io/elb.health-check-flag" : "on",
                  "kubernetes.io/elb.health-check-option" : "{\"protocol\":\"TCP\",\"delay\":\"5\",\"timeout\":\"10\",\"max_retries\":\"3\"}"
                },
              },
              "elb_id" : "ad0e9972-d330-4072-827b-095db7fa711c",
              "access_control" : null,
              "ports" : [
                {
                  "target_port" : 80,
                  "port" : 8002,
                  "protocol" : "TCP",
                }
              ],
            },
            {
              "type" : "Ingress",
              "metadata" : {
                "annotations" : {
                  "kubernetes.io/elb.health-check-flag" : "off",
                  "kubernetes.io/elb.lb-algorithm" : "ROUND_ROBIN"
                },
              },
              "elb_id" : "47bc918f-9ff1-465e-8910-a5154d9aeb0a",
              "ports" : [
                {
                  "target_port" : 80,
                  "port" : 449,
                  "protocol" : "HTTPS",
                  "default_certificate" : "pkcs88",
                  "policy" : "tls-1-2-strict",
                  "paths" : [
                    {
                      "hostname" : "huangtian.com",
                      "path" : "/",
                      "url_match_mode" : "STARTS_WITH",
                    }
                  ]
                }
              ],
            },
            {
              "type": "Ingress",
              "metadata": {
                "annotations": {
                  "kubernetes.io/elb.health-check-flag": "off",
                  "kubernetes.io/elb.lb-algorithm": "ROUND_ROBIN"
                }
              },
              "elb_id": "47bc918f-9ff1-465e-8910-a5154d9aeb0a",
              "ports": [
                {
                  "target_port": 80,
                  "port": 450,
                  "protocol": "HTTP",
                  "paths": [
                    {
                      "hostname": "hft.com"
                      "path": "/",
                      "url_match_mode": "STARTS_WITH",
                    }
                  ]
                }
              ],
            }
          ]
        }
      })
    }
  ]
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
