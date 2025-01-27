# AxonOps™ Server Docker Compose
AxonOps is a comprehensive management platform designed for Apache Cassandra and Apache Kafka, offering unified monitoring, maintenance, and backup functionalities. Built by Cassandra and Kafka experts, it provides the only cloud-native solution to monitor, maintain and backup Apache Cassandra or Apache Kafka clusters through either SaaS or self-hosted deployments.

For detailed documentation, visit:
- Documentation: https://axonops.com/docs
- Product Information: https://axonops.com

## Container Runtime Options
This project can be run using either Docker or [Podman](https://podman.io).

It has been tested on Debian 12 with Docker, although it should work in other environments. Please raise an issue on the project if you encounter any problems specific to your setup.

## Accessing AxonOps

Once the services are running, access the AxonOps dashboard at: http://localhost:3000 and you can confifure you AxonOps agents to point at the AxonOps Server to start managing your cluster.

For production deployments, ensure proper security configurations are in place and refer to the official documentation for advanced setup options.

The platform provides dynamic dashboards for collecting logs and metrics, offering insights into cluster performance and health status. You can set up alerts for various metrics to ensure optimal performance.

## Instructions

### Using Docker
```bash
# Clone repository
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose

# Start services
docker compose up -d
```

### Using Podman
```bash
# Clone repository
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose

# Start services
podman compose up -d
```

## Health Check Script

This project includes a **health check script** (`check_health.sh`) to monitor the status of all services deployed via Docker Compose or Podman Compose. The script ensures that all services are healthy and logs any errors to the system log (`syslog`) for troubleshooting.

### Purpose
The health check script is designed to:
- Verify that the container runtime (Docker or Podman) is functioning correctly.
- Check the health status of all services defined in the `docker-compose.yml` file.
- Log errors to `syslog` if any services are unhealthy or if there are issues with the container runtime.

### Usage

#### Prerequisites
1. Ensure you have either **Docker** or **Podman** installed on your system.
2. Make sure the `check_health.sh` script is executable. If not, run:

```bash
chmod +x check_health.sh
```

#### Running the Script
You can run the script manually or schedule it as a cron job to execute periodically.

##### Manual Execution
To run the script manually, use the following command:

```bash
./check_health.sh [docker|podman]
```

#### Run using Docker (default)
```bash
./check_health.sh
```
#### Run using Podman
```bash
./check_health.sh podman
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

***

This project may contain trademarks or logos for projects, products, or services. Any use of third-party trademarks or logos are subject to those third-party's policies. AxonOps is a registered trademark of AxonOps Limited. Apache, Apache Cassandra, Cassandra, Apache Spark, Spark, Apache TinkerPop, TinkerPop, Apache Kafka and Kafka are either registered trademarks or trademarks of the Apache Software Foundation or its subsidiaries in Canada, the United States and/or other countries.
