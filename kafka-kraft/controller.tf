resource "docker_image" "kraft" {
  name         = "apache/kafka:4.3.1"
  keep_locally = true
}

resource "random_uuid" "cluster_id" {}

locals {
  cluster_id = random_uuid.cluster_id.result
  quorum_voters = "1@kafka-1:9093,2@kafka-2:9093,3@kafka-3:9093"
}

resource "docker_container" "kafka-controller" {
  count = 3
  name  = "kafka-${count.index + 1}"
  image = docker_image.kraft.name
  ports {
    internal = 9092
    external = 9092 + count.index
  }
  ports {
    internal = 9308
    external = 9308 + count.index
  }

  env = [
    "KAFKA_NODE_ID=${count.index + 1}",
    "KAFKA_PROCESS_ROLES=broker,controller",
    "KAFKA_LISTENERS=PLAINTEXT://0.0.0.0:9092,CONTROLLER://0.0.0.0:9093",
    "KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://kafka-${count.index + 1}:9092",
    "KAFKA_CONTROLLER_LISTENER_NAMES=CONTROLLER",
    "KAFKA_LISTENER_SECURITY_PROTOCOL_MAP=PLAINTEXT:PLAINTEXT,CONTROLLER:PLAINTEXT",
    "KAFKA_CONTROLLER_QUORUM_VOTERS=${local.quorum_voters}",
    "KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=3",
    "KAFKA_MIN_INSYNC_REPLICAS=2",
    "KAFKA_TRANSACTION_STATE_LOG_REPLICATION_FACTOR=1",
    "KAFKA_TRANSACTION_STATE_LOG_MIN_ISR=1",
    "KAFKA_GROUP_INITIAL_REBALANCE_DELAY_MS=0",
    "CLUSTER_ID=${local.cluster_id}",
    "KAFKA_OPTS=-javaagent:/opt/jmx/jmx_prometheus_javaagent.jar=9308:/opt/jmx/kafka-jmx.yml"
  ]

  volumes {
    volume_name    = docker_volume.kafka_data[count.index].name
    container_path = "/var/lib/kafka/data"
  }

  mounts {
    target = "/opt/jmx"
    source = "${abspath(path.module)}/files/jmx"
    type = "bind"
  }

  networks_advanced {
    name = docker_network.kafka_kraft.name
    aliases = ["kafka-${count.index + 1}"]
  }

  depends_on = [null_resource.jmx_agent_download]

}