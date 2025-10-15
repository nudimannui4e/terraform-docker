resource "docker_image" "db" {
  name = "postgres:${var.postgres_docker_tag}"
  keep_locally = true
}

resource "docker_container" "db" {
  depends_on = [docker_network.gitea]
  name  = "db"
  image = docker_image.db.name

  env = [
    "POSTGRES_USER=giteadb_user",
    "POSTGRES_PASSWORD=giteadb_password",
    "POSTGRES_DB=giteadb"
  ]

  networks_advanced {
    name = docker_network.gitea.name
  }

}