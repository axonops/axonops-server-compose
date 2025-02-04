# AxonOps™ Server Docker Compose
AxonOps is a comprehensive management platform designed for Apache Cassandra® and Apache Kafka®, offering unified monitoring, maintenance, and backup functionalities. Built by Cassandra and Kafka experts, it provides the only cloud-native solution to monitor, maintain and backup Apache Cassandra or Apache Kafka clusters through either SaaS or self-hosted deployments.

For detailed documentation, visit:
- Demo https://axonops.com/demo-sandbox/
- Documentation: https://axonops.com/docs
- Product Information: https://axonops.com

For other self-host installation options like Kubernetes, see here: https://axonops.com/docs/installation-starter/axon-server/axonserver_install/

# Table of Contents

1. [AxonOps™ Server Docker Compose](#axonops-server-docker-compose)
2. [Self-Hosting AxonOps](#self-hosting-axonops)
   - [Install License (Optional)](#install-license-optional)
3. [Container Runtime Options](#container-runtime-options)
4. [Accessing AxonOps](#accessing-axonops)
5. [Compose Structure](#compose-structure)
   - [Overview](#overview)
   - [Key Components](#key-components)
     - [Volumes](#volumes)
     - [Initialization with BusyBox](#initialization-with-busybox)
   - [Service Details](#service-details)
     - [axon-server](#axon-server)
     - [axon-dash](#axon-dash)
     - [elasticsearch](#elasticsearch)
     - [cassandra](#cassandra)
6. [Notes](#notes)
7. [Instructions](#instructions)
   - [Using Docker](#using-docker)
   - [Using Podman](#using-podman)
8. [Health Check Script](#health-check-script)
   - [Purpose](#purpose)
   - [Usage](#usage)
     - [Prerequisites](#prerequisites)
     - [Running the Script](#running-the-script)
       - [Manual Execution](#manual-execution)
       - [Run using Docker (default)](#run-using-docker-default)
       - [Run using Podman](#run-using-podman)
9. [Useful Commands](#useful-commands)
   - [Container Management](#container-management)
   - [Resource Management](#resource-management)

## Self-Hosting AxonOps
When self-hosting AxonOps using this `docker-compose.yml` file:
1. The **axon-server** service acts as the backend, communicating with agents and exposing REST APIs.
2. The **axon-dash** service provides the dashboards and user interface.
3. Data is stored in:
   - **Elasticsearch®**, which handles indexing and search functionality.
   - **Cassandra**, which manages time-series data storage.

### Install License (Optional)  
AxonOps is free to use and includes a range of powerful features at no cost.

For enterprise customers with a license key, you can enhance your installation by adding the key to the `axon-server.yml` file. Ensure that the organization name matches the one used when obtaining your license.

## Container Runtime Options
This project can be run using either [Docker](https://docker.com) or [Podman](https://podman.io).

It has been tested on Debian 12 with Docker, although it should work in other environments. Please raise an issue on the project if you encounter any problems specific to your setup.

## Accessing AxonOps

Once the services are running, access the AxonOps dashboard at: http://localhost:3000 and you can configure your AxonOps agents to point at the AxonOps Server to start managing your cluster.

For production deployments, ensure proper security configurations are in place and refer to the official documentation for advanced setup options.

The platform provides dynamic dashboards for collecting logs and metrics, offering insights into cluster performance and health status. You can set up alerts for various metrics to ensure optimal performance.

## Compose Structure

The `docker-compose.yml` file in this repository defines the services, networks, and volumes required to self-host AxonOps in this fashion. Below is an explanation of its structure and key components.

### Overview
The `docker-compose.yml` file orchestrates the following services:
1. **axon-server**: The core backend component of AxonOps. This service handles communication with agents and exposes REST APIs for configuration.
2. **axon-dash**: The frontend component providing dashboards and a user interface for interacting with AxonOps.
3. **Elasticsearch®**: A search engine used by AxonOps to store and index data.
4. **Apache Cassandra®**: A distributed NoSQL database used by AxonOps to store time-series data.
5. **busybox (initialization container)**: Ensures proper file permissions for mounted volumes before starting Elasticsearch and Cassandra.

### Key Components

#### **Volumes**
The `docker-compose.yml` file mounts persistent volumes for Elasticsearch and Cassandra to ensure data durability across container restarts. These volumes are critical for storing logs and other data generated by AxonOps.

- **Elasticsearch Volumes**:
  - Mounted to persist Elasticsearch indices and logs.
  - Ensures that all data stored in Elasticsearch remains intact even if the container is restarted.

- **Cassandra Volumes**:
  - Mounted to persist time-series data and other information stored in Cassandra.
  - Guarantees data reliability and availability.

#### **Initialization with BusyBox**
On initialization, a lightweight `busybox` container is used to set the correct file permissions for the mounted volumes. This step ensures that Elasticsearch and Cassandra have the necessary permissions to read from and write to their respective volumes.

The `busybox` container runs a simple script that adjusts file ownership and permissions, then exits once the task is complete. This ensures a smooth startup process for the dependent services.

### Service Details

#### **axon-server**
- Acts as the central hub for AxonOps agents.
- Exposes REST APIs that allow users to configure AxonOps programmatically.
- Handles incoming data from agents, processes it, and stores it in Elasticsearch and Cassandra.

#### **axon-dash**
- Provides the primary user interface for AxonOps.
- Allows users to visualize data, monitor systems, and interact with dashboards.
- Communicates with `axon-server` to fetch data for display.

#### **elasticsearch**
- Stores indexed data required by AxonOps for searching, analytics, and monitoring.
- Configured with mounted volumes to persist indices and logs across restarts.

#### **cassandra**
- Stores time-series data used by AxonOps for long-term storage and analysis.
- Configured with mounted volumes to ensure durability of stored data.

### Notes
- Ensure that the mounted volumes have appropriate permissions before starting the services. The `busybox` initialization container takes care of this automatically during startup.
- Both Elasticsearch and Cassandra are resource-intensive services; ensure your hosting environment has sufficient resources (CPU, memory, disk space) to handle their requirements effectively.

This structure ensures a robust deployment of AxonOps with all necessary components running seamlessly together in a single Docker Compose setup.

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

This project may contain trademarks or logos for projects, products, or services. Any use of third-party trademarks or logos are subject to those third-party's policies. AxonOps is a registered trademark of AxonOps Limited. Apache, Apache Cassandra, Cassandra, Apache Spark, Spark, Apache TinkerPop, TinkerPop, Apache Kafka and Kafka are either registered trademarks or trademarks of the Apache Software Foundation or its subsidiaries in Canada, the United States and/or other countries. Elasticsearch is a trademark of Elasticsearch B.V., registered in the U.S. and in other countries. Docker is a trademark or registered trademark of Docker, Inc. in the United States and/or other countries.
