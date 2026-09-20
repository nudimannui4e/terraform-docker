resource "docker_volume" "kafka_data" {
  name = "kafka_data"
}

resource "docker_volume" "kraft_data" {
  name = "kraft_data"
}