#!/bin/bash

set -e

# Default memory configurations (in GB)
ELASTICSEARCH_HEAP_SIZE=${ELASTICSEARCH_HEAP_SIZE:-8}
CASSANDRA_HEAP_SIZE=${CASSANDRA_HEAP_SIZE:-8}
CASSANDRA_HEAP_NEWSIZE=${CASSANDRA_HEAP_NEWSIZE:-800m}

# Color output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Function to print colored messages
print_info() {
    echo -e "${GREEN}[INFO]${NC} $1"
}

print_warn() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Function to display usage
usage() {
    cat << EOF
Usage: $0 [OPTIONS]

Run AxonOps Server with Docker Compose

OPTIONS:
    -h, --help                              Show this help message
    -d, --detach                            Run in detached mode
    --es-heap SIZE                          Elasticsearch heap size (default: ${ELASTICSEARCH_HEAP_SIZE}g)
    --cassandra-heap SIZE                   Cassandra heap size (default: ${CASSANDRA_HEAP_SIZE}g)
    --cassandra-heap-newsize SIZE           Cassandra new generation heap size (default: ${CASSANDRA_HEAP_NEWSIZE})
    --down                                  Stop and remove containers
    --clean                                 Stop containers and remove volumes (WARNING: data will be lost)

EXAMPLES:
    # Run with default settings
    $0

    # Run with custom Elasticsearch heap
    $0 --es-heap 16

    # Run with custom memory for both services
    $0 --es-heap 16 --cassandra-heap 16

    # Run in detached mode
    $0 -d

    # Stop services
    $0 --down

    # Clean everything including data
    $0 --clean

ENVIRONMENT VARIABLES:
    ELASTICSEARCH_HEAP_SIZE                 Default: 8 (GB)
    CASSANDRA_HEAP_SIZE                     Default: 8 (GB)
    CASSANDRA_HEAP_NEWSIZE                  Default: 800m
EOF
}

# Parse command line arguments
DETACHED=""
ACTION="up"

while [[ $# -gt 0 ]]; do
    case $1 in
        -h|--help)
            usage
            exit 0
            ;;
        -d|--detach)
            DETACHED="-d"
            shift
            ;;
        --es-heap)
            ELASTICSEARCH_HEAP_SIZE="$2"
            shift 2
            ;;
        --cassandra-heap)
            CASSANDRA_HEAP_SIZE="$2"
            shift 2
            ;;
        --cassandra-heap-newsize)
            CASSANDRA_HEAP_NEWSIZE="$2"
            shift 2
            ;;
        --down)
            ACTION="down"
            shift
            ;;
        --clean)
            ACTION="clean"
            shift
            ;;
        *)
            print_error "Unknown option: $1"
            usage
            exit 1
            ;;
    esac
done

# Handle down and clean actions
if [ "$ACTION" = "down" ]; then
    print_info "Stopping AxonOps Server containers..."
    docker-compose down
    exit 0
fi

if [ "$ACTION" = "clean" ]; then
    print_warn "This will remove all containers, networks, and volumes (including data)!"
    read -p "Are you sure? (yes/no): " -r
    if [[ $REPLY =~ ^[Yy][Ee][Ss]$ ]]; then
        print_info "Cleaning up AxonOps Server..."
        docker-compose down -v
        print_info "Cleanup complete"
    else
        print_info "Cleanup cancelled"
    fi
    exit 0
fi

# Check if required config files exist
if [ ! -f "./axon-server.yml" ]; then
    print_error "axon-server.yml not found in current directory"
    exit 1
fi

if [ ! -f "./axon-dash.yml" ]; then
    print_error "axon-dash.yml not found in current directory"
    exit 1
fi

# Display configuration
print_info "Starting AxonOps Server with the following configuration:"
echo ""
echo "  Elasticsearch:"
echo "    Heap Size:          ${ELASTICSEARCH_HEAP_SIZE}g"
echo ""
echo "  Cassandra:"
echo "    Heap Size:          ${CASSANDRA_HEAP_SIZE}g"
echo "    New Gen Heap Size:  ${CASSANDRA_HEAP_NEWSIZE}"
echo ""

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    print_error "Docker is not running. Please start Docker and try again."
    exit 1
fi

# Start services
print_info "Starting services..."
export ELASTICSEARCH_HEAP_SIZE
export CASSANDRA_HEAP_SIZE
export CASSANDRA_HEAP_NEWSIZE
docker-compose up $DETACHED

if [ -n "$DETACHED" ]; then
    echo ""
    print_info "Services started in detached mode"
    print_info "Access AxonOps Dashboard at: http://localhost:3000"
    print_info "Cassandra port: 9042"
    print_info "AxonOps Server port: 1888"
    echo ""
    print_info "To view logs: docker-compose logs -f"
    print_info "To stop: $0 --down"
fi
