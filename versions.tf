terraform {

  backend "s3" {}

  required_version = ">= 1.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.0"
    }
    # docker = {
    #   source  = "kreuzwerker/docker"
    #   version = "~> 2.17.0"
    # }
  }
}

provider "aws" {
  region = var.region
}

locals {
  mallory_local_normal_port = "1315"
  mallory_local_smart_port  = "1316"
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
  proxy_url   = "http://localhost:${local.mallory_local_smart_port}"
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
    proxy_url   = "http://localhost:${local.mallory_local_smart_port}"
  }
}
