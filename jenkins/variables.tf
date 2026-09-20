variable "container_name" {
  description = "Docker container name"
  type        = string
  default     = "jenkins"
}

variable "docker_image_name" {
  description = "Docker name id from DockerHub"
  type        = string
  default     = "jenkins/jenkins"
}

variable "docker_image_tag" {
  description = "Docker images tag"
  type        = string
  default     = "lts"
}

variable "http_port_container" {
  description = "Container http port"
  type        = number
  default     = 8080
}

variable "http_port_host" {
  description = "Forwarding container port to host port"
  type        = number
  default     = 8080
}
