# ---------- kafka_exporter ----------
resource "docker_image" "kafka_exporter" {
  name         = "danielqsj/kafka-exporter:latest"
  keep_locally = true
}

resource "docker_container" "kafka_exporter" {
  name  = "kafka-exporter"
  image = docker_image.kafka_exporter.name

  ports {
    internal = 9404
    external = 9404
  }

  command = [
    "--kafka.server=kafka-1:9092",
    "--kafka.server=kafka-2:9092",
    "--kafka.server=kafka-3:9092",
    "--web.listen-address=:9404"
  ]

  networks_advanced {
    name = docker_network.kafka_kraft.name
  }

  depends_on = [docker_container.kafka-controller]
}

# ---------- Prometheus ----------
resource "docker_image" "prometheus" {
  name         = "prom/prometheus:latest"
  keep_locally = true
}

resource "docker_container" "prometheus" {
  name  = "prometheus"
  image = docker_image.prometheus.name

  ports {
    internal = 9090
    external = 9090
  }

  volumes {
    volume_name    = docker_volume.prometheus_data.name
    container_path = "/prometheus"
  }

  mounts {
    target = "/etc/prometheus/prometheus.yml"
    source = "${abspath(path.module)}/files/prometheus/prometheus.yml"
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.kafka_kraft.name
  }

  depends_on = [
    docker_container.kafka-controller,
    docker_container.kafka_exporter
  ]
}

# ---------- Grafana ----------
resource "docker_image" "grafana" {
  name         = "grafana/grafana:latest"
  keep_locally = true
}

resource "docker_container" "grafana" {
  name  = "grafana"
  image = docker_image.grafana.name

  ports {
    internal = 3000
    external = 3000
  }

  volumes {
    volume_name    = docker_volume.grafana_data.name
    container_path = "/var/lib/grafana"
  }

  mounts {
    target = "/etc/grafana/provisioning/datasources"
    source = "${abspath(path.module)}/files/grafana/provisioning/datasources"
    type   = "bind"
  }

  networks_advanced {
    name = docker_network.kafka_kraft.name
  }

  depends_on = [docker_container.prometheus]
}