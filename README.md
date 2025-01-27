# AxonOps™ Server Docker Compose

AxonOps is a comprehensive management platform designed for Apache Cassandra and Apache Kafka, offering unified monitoring, maintenance, and backup functionalities. Built by Cassandra and Kafka experts, it provides the only cloud-native solution to monitor, maintain and backup Apache Cassandra or Apache Kafka clusters through either SaaS or self-hosted deployments.

For detailed documentation, visit:
- Documentation: https://axonops.com/docs
- Product Information: https://axonops.com

## Container Runtime Options
This project can be run using either Docker or [Podman](https://podman.io).

While Docker is the most widely used container runtime and perfectly suitable for running AxonOps, Podman offers some compelling features like its Apache Licence, daemonless architecture and enhanced security through rootless execution by default. Choose the runtime that best suits your needs and environment.

## Installation Instructions

### Using Docker
```bash
# Clone repository
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose

# Start services
docker compose up -d
```

### Using Podman on Mac
```bash
# Clone repository
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose

# Start services
podman compose up -d
```

### Using Podman on Windows
```bash
# Clone repository
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose

# Start services
podman compose up -d
```

### Using Podman on Linux
```bash
# Clone repository
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose

# Start services
podman compose up -d
```

## Useful Commands
Commands work the same way for both Docker and Podman - just replace `podman` with `docker` as needed.

**Container Management**
```bash
# List containers
podman ps -a

# Stop all containers
podman compose down

# View container logs
podman logs <container_name>

# Container stats
podman stats

# Pull latest images
podman compose pull

# Restart services
podman compose restart
```

**Resource Management**
```bash
# View disk usage
podman system df

# Clean up unused resources
podman system prune

# View system information
podman system info
```

## Accessing AxonOps

Once the services are running, access the AxonOps dashboard at: http://localhost:3000

For production deployments, ensure proper security configurations are in place and refer to the official documentation for advanced setup options.

The platform provides dynamic dashboards for collecting logs and metrics, offering insights into cluster performance and health status. You can set up alerts for various metrics to ensure optimal performance.



***

This project may contain trademarks or logos for projects, products, or services. Any use of third-party trademarks or logos are subject to those third-party's policies. AxonOps is a registered trademark of AxonOps Limited. Apache, Apache Cassandra, Cassandra, Apache Spark, Spark, Apache TinkerPop, TinkerPop, Apache Kafka and Kafka are either registered trademarks or trademarks of the Apache Software Foundation or its subsidiaries in Canada, the United States and/or other countries.
