terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "4.6.0"
    }
    null = {
        source = "hashicorp/null"
        version = "~> 3.2"
    }
  }
}

provider "docker" {}
