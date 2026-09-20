resource "null_resource" "jmx_agent_download" {
  triggers = {
    jar_url = "https://github.com/prometheus/jmx_exporter/releases/download/1.0.1/jmx_prometheus_javaagent-1.0.1.jar"
  }
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p files/jmx
      curl -L -o files/jmx/jmx_prometheus_javaagent.jar ${self.triggers.jar_url}
    EOT
  }
}