resource "docker_image" "jenkins_image" {
  name         = "${var.docker_image_name}:${var.docker_image_tag}"
  keep_locally = true
}

resource "docker_container" "jenkins_container" {
  name       = var.container_name
  depends_on = [docker_network.jenkins_network]
  image      = docker_image.jenkins_image.name
  ports {
    internal = var.http_port_container
    external = var.http_port_host
  }
}

