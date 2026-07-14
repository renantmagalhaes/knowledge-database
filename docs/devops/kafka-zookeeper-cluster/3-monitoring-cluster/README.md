This stack uses:

* [Kafka exporter](https://github.com/danielqsj/kafka_exporter)
* [Prometheus](https://prometheus.io/)
* [Grafana](https://grafana.com/)


In this setup i use a external grafana server, but you can also run it with docker-compose

Ports to open

    * 7072 - jmx exporter
    * 9308  - kafka exporter
    * 9090 prometheus