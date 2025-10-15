variable "gitea_docker_tag" {
  type = string
  default = "1.24-rootless"
  description = "Docker tag gitea"
}

variable "postgres_docker_tag" {
  type = string
  default = "14-alpine"
  description = "Docker tag postgresql"
}