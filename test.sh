#!/data/data/com.termux/files/usr/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Function to print errors
error() {
    echo -e "${RED}✗ $1${NC}"
}

# Function to print success
success() {
    echo -e "${GREEN}✓ $1${NC}"
}

# Function to print info
info() {
    echo -e "${YELLOW}➜ $1${NC}"
}

BASE_URL="${BASE_URL:-http://127.0.0.1:8080}"

echo -e "${BLUE}=== Bo_AI API Test ===${NC}"
echo

# Test 1: Check server connectivity
echo -e "${YELLOW}Test 1: Server Connectivity${NC}"
if curl -s "$BASE_URL/health" > /dev/null 2>&1 || curl -s "$BASE_URL/v1/models" > /dev/null 2>&1; then
    success "Server is reachable at $BASE_URL"
else
    error "Cannot reach server at $BASE_URL"
    echo
    echo "Solutions:"
    echo "  1. Check if start.sh is running in another Termux session"
    echo "  2. Verify the URL: $BASE_URL"
    echo "  3. Wait a few seconds for the server to fully start"
    echo "  4. Check port is correct: PORT=8080"
    echo
    exit 1
fi

echo

# Test 2: List available models
echo -e "${YELLOW}Test 2: List Models${NC}"
MODELS=$(curl -s "$BASE_URL/v1/models")

if echo "$MODELS" | grep -q "local-model"; then
    success "Model endpoint responding"
    echo "Response:"
    echo "$MODELS" | head -20
else
    error "Unexpected response from /v1/models"
    echo "$MODELS"
    exit 1
fi

echo

# Test 3: Simple chat completion (non-streaming)
echo -e "${YELLOW}Test 3: Simple Chat Completion${NC}"
info "Sending test prompt to model..."

RESPONSE=$(curl -s -X POST "$BASE_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {"role": "user", "content": "What is 2+2? Answer in one sentence."}
    ],
    "temperature": 0.0,
    "max_tokens": 50
  }')

if echo "$RESPONSE" | grep -q "choices"; then
    success "Chat completion working!"
    echo
    echo "Model response:"
    echo "$RESPONSE" | grep -o '"content":"[^"]*"' | head -1 | sed 's/"content":"//' | sed 's/"$//'
else
    error "Chat completion failed"
    echo "$RESPONSE"
    exit 1
fi

echo

# Test 4: Streaming chat completion
echo -e "${YELLOW}Test 4: Streaming Chat Completion${NC}"
info "Sending streaming request..."

echo -n "Response: "
curl -s -X POST "$BASE_URL/v1/chat/completions" \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {"role": "user", "content": "Say hello briefly."}
    ],
    "temperature": 0.0,
    "max_tokens": 30,
    "stream": true
  }' | grep -o '"content":"[^"]*"' | sed 's/"content":"//' | sed 's/"$//' | tr -d '\n'

echo
echo

echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ All tests passed!${NC}"
echo -e "${GREEN}========================================${NC}"
echo
echo "Your API is ready for use:"
echo
echo "Chatbox AI settings:"
echo "  Base URL: $BASE_URL/v1"
echo "  API Key: local"
echo "  Model: local-model"
echo "  Temperature: 0.0 (for factual accuracy)"
echo
echo "API Examples:"
echo
echo "1. List models:"
echo "   curl $BASE_URL/v1/models"
echo
echo "2. Chat with facts only (temperature 0.0):"
echo "   curl -X POST $BASE_URL/v1/chat/completions \\"
echo '     -H "Content-Type: application/json" \'
echo "     -d '{\"model\":\"local-model\",\"messages\":[{\"role\":\"user\",\"content\":\"Your prompt\"}],\"temperature\":0.0}'"
echo
echo "3. Chat streaming (real-time):"
echo "   curl -X POST $BASE_URL/v1/chat/completions \\"
echo '     -H "Content-Type: application/json" \'
echo "     -d '{\"model\":\"local-model\",\"messages\":[{\"role\":\"user\",\"content\":\"Your prompt\"}],\"stream\":true}'"
echo
echo "See README.md for more details."
echo
