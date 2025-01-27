#!/bin/bash

# Log to syslog function
log_error() {
    local message="$1"
    logger -t container-health-check "ERROR: $message"
}

# Default container runtime
CONTAINER_RUNTIME="docker"

# Parse command-line argument for container runtime
if [[ "$1" == "podman" ]]; then
    CONTAINER_RUNTIME="podman"
elif [[ "$1" != "" && "$1" != "docker" ]]; then
    echo "Invalid argument. Use 'docker' or 'podman'."
    exit 1
fi

# Check if the selected container runtime is installed
if ! command -v "$CONTAINER_RUNTIME" &> /dev/null; then
    log_error "$CONTAINER_RUNTIME is not installed or not in PATH."
    exit 1
fi

# Check if the compose plugin is available for the selected runtime
if ! "$CONTAINER_RUNTIME" compose version &> /dev/null; then
    log_error "$CONTAINER_RUNTIME compose plugin is not available."
    exit 1
fi

# Navigate to the directory containing the docker-compose.yml file
COMPOSE_DIR="/path/to/your/docker-compose.yml"
cd "$COMPOSE_DIR" || { log_error "Failed to navigate to $COMPOSE_DIR"; exit 1; }

# Check if services are running using the selected runtime
if ! "$CONTAINER_RUNTIME" compose ps &> /dev/null; then
    log_error "$CONTAINER_RUNTIME compose services are not running."
    exit 1
fi

# Get the list of services and their health statuses
services=$("$CONTAINER_RUNTIME" compose ps --services)
exit_code=0

for service in $services; do
    # Check health status for each service
    health_status=$("$CONTAINER_RUNTIME" inspect --format='{{json .State.Health.Status}}' "$("$CONTAINER_RUNTIME" compose ps -q "$service")" 2>/dev/null | tr -d '"')
    
    if [[ $? -ne 0 ]]; then
        log_error "Failed to retrieve health status for service: $service"
        exit_code=1
        continue
    fi

    if [[ "$health_status" != "healthy" ]]; then
        log_error "Service $service is not healthy. Current status: $health_status"
        exit_code=1
    fi
done

exit $exit_code

