#!/data/data/com.termux/files/usr/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print errors
error() {
    echo -e "${RED}ERROR: $1${NC}" >&2
    exit 1
}

# Function to print success
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print info
info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

# Load configuration if it exists
if [ -f "$(dirname "$0")/config.sh" ]; then
    source "$(dirname "$0")/config.sh"
fi

# Default settings (can be overridden by environment variables or config.sh)
MODEL_PATH="${MODEL_PATH:-$HOME/models/model.gguf}"
HOST="${HOST:-127.0.0.1}"
PORT="${PORT:-8080}"
CTX_SIZE="${CTX_SIZE:-4096}"
THREADS="${THREADS:-2}"
GPU_LAYERS="${GPU_LAYERS:-0}"

echo -e "${BLUE}=== Bo_AI Termux Server ===${NC}"
echo

# Validate model file exists
if [ ! -f "$MODEL_PATH" ]; then
    echo -e "${RED}ERROR: GGUF model not found${NC}"
    echo
    echo "Model path: $MODEL_PATH"
    echo
    echo "Solution:"
    echo "  1. Download a GGUF model (e.g., Dolphin 3.0)"
    echo "  2. Place it in: $HOME/models/"
    echo "  3. Run with:"
    echo
    echo "     MODEL_PATH=\"\$HOME/models/my-model.gguf\" ./start.sh"
    echo
    echo "Uncensored model recommendations:"
    echo "  - Dolphin 3.0 (unrestricted, best reasoning)"
    echo "  - Hermes 2 (factual, instruction-following)"
    echo "  - Mistral (balanced, neutral)"
    echo "  - Llama 2 (open-source, no safety filtering)"
    echo
    echo "See README.md for model download links."
    exit 1
fi

# Validate llama-server exists
SERVER="$HOME/llama.cpp/build/bin/llama-server"
if [ ! -x "$SERVER" ]; then
    error "llama-server not found at $SERVER. Run ./install.sh first."
fi

echo -e "${GREEN}Configuration:${NC}"
echo "  Model: $MODEL_PATH"
echo "  Host: $HOST"
echo "  Port: $PORT"
echo "  Context: $CTX_SIZE tokens"
echo "  Threads: $THREADS"
echo "  GPU Layers: $GPU_LAYERS"
echo

# Get model file size
MODEL_SIZE=$(du -h "$MODEL_PATH" | cut -f1)
echo "  Model size: $MODEL_SIZE"
echo

# Estimate memory usage
MEMORY_EST=$((CTX_SIZE / 512)) # Rough estimate
echo -e "${YELLOW}Estimated RAM usage: ~${MEMORY_EST}MB + model size${NC}"
echo

echo "Starting llama-server..."
echo

# Trap signals for graceful shutdown
trap 'echo -e "\n${YELLOW}Shutting down...${NC}"; exit 0' INT TERM

# Start the server
exec "$SERVER" \
    -m "$MODEL_PATH" \
    --host "$HOST" \
    --port "$PORT" \
    -c "$CTX_SIZE" \
    -t "$THREADS" \
    --gpu-layers "$GPU_LAYERS" \
    --alias local-model \
    --log-format text
