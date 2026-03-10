# AxonOps Server Docker Compose

AxonOps is a management platform for Apache Cassandra and Apache Kafka, offering monitoring, maintenance, and backup capabilities. This repository provides a simple way to run AxonOps locally using Docker Compose.

**Links:**
- [Live Demo](https://axonops.com/demo-sandbox/)
- [Documentation](https://axonops.com/docs)
- [Product Website](https://axonops.com)
- [Kubernetes Installation](https://axonops.com/docs/installation/kubernetes/)

---

## Prerequisites

Before you begin, make sure you have:

1. **Docker Desktop** (recommended for beginners) or **Docker Engine** installed
   - [Download Docker Desktop](https://www.docker.com/products/docker-desktop/) (Windows/Mac/Linux)
   - Docker Desktop includes Docker Compose

2. **Minimum System Requirements:**
   - 4 GB RAM available for Docker (8 GB recommended)
   - 10 GB free disk space
   - macOS, Windows 10/11, or Linux

3. **Verify Docker is installed** by opening a terminal and running:
   ```bash
   docker --version
   docker compose version
   ```
   You should see version numbers for both commands.

---

## Quick Start

### Step 1: Download the project

```bash
git clone https://github.com/axonops/axonops-server-compose
cd axonops-server-compose
```

Or [download the ZIP file](https://github.com/axonops/axonops-server-compose/archive/refs/heads/main.zip) and extract it.

### Step 2: Start AxonOps

```bash
docker compose up -d
```

This command:
- Downloads the required container images (first time only)
- Starts all services in the background (`-d` means "detached")
- May take 2-5 minutes on first run

### Step 3: Wait for services to be ready

Check the status of all services:
```bash
docker compose ps
```

Wait until all services show `healthy` in the STATUS column. You can also watch the logs:
```bash
docker compose logs -f
```

Press `Ctrl+C` to stop watching logs.

### Step 4: Access the dashboard

Open your web browser and go to: **http://localhost:3000**

You're now ready to configure your AxonOps agents to connect to the server on port `1888`.

---

## Managing AxonOps

### View running services
```bash
docker compose ps
```

### View logs
```bash
# All services
docker compose logs -f

# Specific service
docker compose logs -f axon-server
```

### Stop AxonOps (keeps your data)
```bash
docker compose down
```

### Start AxonOps again
```bash
docker compose up -d
```

### Stop and delete all data (fresh start)
```bash
docker compose down -v
```

> **Warning:** The `-v` flag removes all stored data. Only use this if you want to start fresh.

---

## Configuration

### Memory Settings

By default, the services use conservative memory settings suitable for development:
- OpenSearch: 2 GB heap
- Cassandra: 1 GB heap

For production or larger workloads, increase the memory by setting environment variables before starting:

```bash
# Set custom memory (before running docker compose up)
export OPENSEARCH_HEAP_SIZE=4g
export CASSANDRA_HEAP_SIZE=4096M

# Then start services
docker compose up -d
```

Or set them inline:
```bash
OPENSEARCH_HEAP_SIZE=4g CASSANDRA_HEAP_SIZE=4096M docker compose up -d
```

### Authentication

The services use default credentials. For production deployments, change these by setting environment variables:

```bash
export AXONOPS_SEARCH_USER=admin
export AXONOPS_SEARCH_PASSWORD=your-secure-password
export AXONOPS_DB_USERNAME=your-secure-password
```

### License Key (Optional)

AxonOps is free to use. Enterprise customers with a license key can add it to `axon-server.yml`:

```yaml
license_key: "your-license-key"
org: "your-organization-name"
```

---

## Architecture

This setup runs four services:

| Service | Description | Port |
|---------|-------------|------|
| **axon-server** | Backend API server - handles agent connections and data processing | 1888 (agents), 8080 (API) |
| **axon-dash** | Web dashboard for monitoring and configuration | 3000 |
| **axondb-search** | OpenSearch database for indexing and search | 9200 (internal) |
| **timseriesdb** | Cassandra database for time-series data storage | 9042 |

### Data Storage

Your data is stored in Docker volumes, which persist across restarts:

| Volume | Purpose |
|--------|---------|
| `searchdb_data` | OpenSearch indices and data |
| `timeseriesdb_data` | Cassandra time-series data |
| `axonops_logs` | Application logs |

To see your volumes:
```bash
docker volume ls
```

---

## Troubleshooting

### Services won't start or keep restarting

1. **Check available memory:**
   ```bash
   docker stats --no-stream
   ```
   If memory is maxed out, increase Docker's memory limit in Docker Desktop settings, or reduce heap sizes.

2. **Check logs for errors:**
   ```bash
   docker compose logs axondb-search
   docker compose logs timseriesdb
   ```

3. **Restart everything fresh:**
   ```bash
   docker compose down -v
   docker compose up -d
   ```

### "Cannot connect to the Docker daemon"

- **Mac/Windows:** Make sure Docker Desktop is running
- **Linux:** Start the Docker service: `sudo systemctl start docker`

### "Port already in use"

Another application is using port 3000, 1888, or 9042. Either:
- Stop the other application
- Or edit `docker-compose.yml` to use different ports (e.g., change `"3000:3000"` to `"3001:3000"`)

### Services are "unhealthy"

Wait a few minutes - the databases need time to initialize. If they stay unhealthy:
```bash
# Check what's wrong
docker compose logs axondb-search
docker compose logs timseriesdb

# Try restarting
docker compose restart
```

### Dashboard shows "Cannot connect to server"

The axon-server may still be starting. Wait for it to become healthy:
```bash
docker compose ps
```

---

## Using Podman (Alternative to Docker)

If you prefer Podman:
```bash
podman compose up -d
podman compose ps
podman compose down
```

---

## Health Check Script

The `check_health.sh` script verifies all services are running correctly:

```bash
./check_health.sh
```

If everything is healthy, you'll see no output. If there are problems, you'll see error messages like:
```
ERROR: Service timseriesdb is not running
ERROR: Service axondb-search is not healthy. Current status: starting
```

For Podman users:
```bash
./check_health.sh podman
```

---

## Useful Commands Reference

| Task | Command |
|------|---------|
| Start services | `docker compose up -d` |
| Stop services | `docker compose down` |
| View status | `docker compose ps` |
| View logs | `docker compose logs -f` |
| Restart a service | `docker compose restart axon-server` |
| Delete everything | `docker compose down -v` |
| Update images | `docker compose pull && docker compose up -d` |

---

## Getting Help

- **Documentation:** https://axonops.com/docs
- **Issues:** https://github.com/axonops/axonops-server-compose/issues
- **Support:** https://axonops.com/contact

---

*This project may contain trademarks or logos for projects, products, or services. Any use of third-party trademarks or logos are subject to those third-party's policies. AxonOps is a registered trademark of AxonOps Limited. Apache, Apache Cassandra, Cassandra, Apache Kafka and Kafka are either registered trademarks or trademarks of the Apache Software Foundation. Docker is a trademark of Docker, Inc. OpenSearch is a trademark of Amazon Web Services.*
