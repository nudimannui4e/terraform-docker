resource "null_resource" "jmx_agent_download" {
  triggers = {
    jar_url = "https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/1.0.1/jmx_prometheus_javaagent-1.0.1.jar"
  }
  provisioner "local-exec" {
    command = <<-EOT
      mkdir -p files/jmx
      curl -fL -o files/jmx/jmx_prometheus_javaagent.jar ${self.triggers.jar_url}
      test -s files/jmx/jmx_prometheus_javaagent.jar
      file files/jmx/jmx_prometheus_javaagent.jar | grep -q "Java archive" || (echo "Not a JAR!" && exit 1)
    EOT
  }
}