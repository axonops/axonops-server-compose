# AxonOps Server Docker Compose

This Docker Compose configuration sets up an AxonOps server and dashboard with Elasticsearch and Cassandra for data storage.

## Instructions
1. Clone this repository
2. Optional: Set your organisation name and license key in `axon-server.yml`
3. Start the service with `docker compose up -d`
4. Install the AxonOps agent on your cassandra servers and connect them to this service
5. Point a web browser at http://\<your-axonops-server\>:3000/
