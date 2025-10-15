resource "docker_image" "gitea" {
  name = "gitea/gitea:${var.gitea_docker_tag}"
  keep_locally = true
}

resource "docker_container" "gitea" {
  depends_on = [docker_network.gitea, docker_container.db]
  name = "gitea"
  image = docker_image.gitea.name
  # HTTP
  ports {
    internal = 3000
    external = 3000
  }
  # SSH
  ports {
    internal = 2222
    external = 2222
  }

  env = [
    "GITEA__database__DB_TYPE=postgres",
    "GITEA__database__HOST=db:5432",
    "GITEA__database__NAME=giteadb",
    "GITEA__database__USER=giteadb_user",
    "GITEA__database__PASSWD=giteadb_password",
    "USER_UID=1000",
    "USER_GID=1000"
  ]

  networks_advanced {
    name = docker_network.gitea.name
  }
}