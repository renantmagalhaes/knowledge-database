#Create basic folders
mkdir -p $HOME/data/prometheus \
&& mkdir -p  $HOME/bin/kafka/libs




wget https://repo1.maven.org/maven2/io/prometheus/jmx/jmx_prometheus_javaagent/0.9/jmx_prometheus_javaagent-0.9.jar

wget https://raw.githubusercontent.com/prometheus/jmx_exporter/master/example_configs/kafka-0-8-2.yml