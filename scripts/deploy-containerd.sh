#!/bin/bash
set -e

IMAGE="ghcr.io/2004island/searanch:latest"
CONTAINER_NAME="searanch-docs"
PORT="${PORT:-8080}"

echo "Pulling latest image..."
nerdctl pull "$IMAGE"

echo "Stopping existing container (if any)..."
nerdctl stop "$CONTAINER_NAME" 2>/dev/null || true
nerdctl rm "$CONTAINER_NAME" 2>/dev/null || true

echo "Starting new container..."
nerdctl run -d \
  --name "$CONTAINER_NAME" \
  --restart=unless-stopped \
  -p "$PORT:80" \
  "$IMAGE"

echo "Container started on port $PORT"
echo "View logs: nerdctl logs -f $CONTAINER_NAME"
