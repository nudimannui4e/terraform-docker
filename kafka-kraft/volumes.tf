resource "docker_volume" "kafka_data" {
  count = 3
  name = "kafka_data_${count.index + 1}"
}

resource "docker_volume" "prometheus_data" {
    name = "prometheus_data"
}

resource "docker_volume" "grafana_data" {
    name = "grafana_data"
}