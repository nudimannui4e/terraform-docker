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

provider "docker" {
  // docker context ls
  // указываем путь к сокету
  host = "unix:///Users/ivliev/.docker/run/docker.sock"
}