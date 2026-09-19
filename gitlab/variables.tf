variable "container_name" {
  description = "Value of the name for the Docker container"
  type        = string
  default     = "GitlabContainer"
}

variable "docker_image" {
  description = "Value of the image for the Docker container"
  type        = string
  default     = "alpinelinux/gitlab:19.1.8"
}

variable "http_port_internal" {
  description = "Container http port (default 80)"
  type        = number
  default     = 80
}

variable "http_port_external" {
  description = "Host http port (default 8080)"
  type        = number
  default     = 8080
}

variable "ssh_port_container" {
  description = "Container ssh port (default 22)"
  type        = number
  default     = 22
}

variable "ssh_port_host" {
  description = "Host ssh port (default 2222)"
  type        = number
  default     = 2222
}
