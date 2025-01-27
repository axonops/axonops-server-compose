# AxonOps™ Server Docker Compose

This Podman or Docker Compose configuration sets up an AxonOps server and dashboard with Elasticsearch and Cassandra for data storage.

## Instructions
1. Clone this repository
2. Optional: Set your organisation name and license key in `axon-server.yml`
3. Start the service with `docker compose up -d` or `podman compose up -d`
4. Install the AxonOps agent on your cassandra servers and connect them to this service
5. Point a web browser at http://\<your-axonops-server\>:3000/




***

This project may contain trademarks or logos for projects, products, or services. Any use of third-party trademarks or logos are subject to those third-party's policies. AxonOps is a registered trademark of AxonOps Limited. Apache, Apache Cassandra, Cassandra, Apache Spark, Spark, Apache TinkerPop, TinkerPop, Apache Kafka and Kafka are either registered trademarks or trademarks of the Apache Software Foundation or its subsidiaries in Canada, the United States and/or other countries.
