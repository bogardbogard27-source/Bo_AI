#!/data/data/com.termux/files/usr/bin/bash
set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${GREEN}=== Bo_AI Termux Installation ===${NC}"
echo

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

# Check if running in Termux
if [ ! -d "$HOME/.termux" ]; then
    error "This script must be run in Termux. Install Termux from F-Droid or Google Play."
fi

info "Updating package manager..."
pkg update || error "Failed to update packages. Check your internet connection."
success "Package manager updated"

echo

# Check and install required tools
echo "Installing dependencies..."

REQUIRED_PACKAGES=("git" "cmake" "clang" "make")

for pkg in "${REQUIRED_PACKAGES[@]}"; do
    if command -v "$pkg" &> /dev/null; then
        success "$pkg already installed"
    else
        info "Installing $pkg..."
        pkg install -y "$pkg" || error "Failed to install $pkg"
        success "$pkg installed"
    fi
done

echo

# Create models directory
info "Creating models directory..."
mkdir -p "$HOME/models"
success "Models directory ready at $HOME/models"

echo

# Clone or update llama.cpp
info "Checking llama.cpp repository..."

if [ ! -d "$HOME/llama.cpp" ]; then
    info "Cloning llama.cpp from GitHub..."
    git clone https://github.com/ggml-org/llama.cpp.git "$HOME/llama.cpp" || error "Failed to clone llama.cpp"
    success "llama.cpp cloned"
else
    success "llama.cpp already exists"
fi

echo

# Build llama.cpp
info "Building llama.cpp (this may take 5-15 minutes)..."
echo "This includes compiling the llama-server and all dependencies."
echo

cd "$HOME/llama.cpp" || error "Failed to navigate to llama.cpp directory"

# Clean previous builds if they exist
if [ -d "build" ]; then
    info "Cleaning previous build..."
    rm -rf build
fi

# Configure with CMake
info "Running CMake configuration..."
cmake -B build || error "CMake configuration failed. Check that cmake and clang are installed."
success "CMake configuration complete"

echo

# Build
info "Compiling llama.cpp (this takes a while)..."
cmake --build build --config Release -j2 || error "Build failed. Check compiler errors above."
success "llama.cpp built successfully"

echo

# Verify llama-server exists
SERVER="$HOME/llama.cpp/build/bin/llama-server"
if [ ! -x "$SERVER" ]; then
    error "Build completed but llama-server executable not found at $SERVER"
fi

echo
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}✓ Installation Complete!${NC}"
echo -e "${GREEN}========================================${NC}"
echo
echo "Next steps:"
echo
echo "1. Place a GGUF model in:"
echo "   $HOME/models/dolphin-3.0.gguf"
echo "   (or any other uncensored GGUF model)"
echo
echo "2. Start the server:"
echo "   MODEL_PATH=\"\$HOME/models/dolphin-3.0.gguf\" ./start.sh"
echo
echo "3. In another Termux session, test the API:"
echo "   ./test.sh"
echo
echo "4. Connect Chatbox AI:"
echo "   - Base URL: http://127.0.0.1:8080/v1"
echo "   - API Key: local"
echo "   - Model: local-model"
echo "   - Temperature: 0.0 (for factual accuracy, no hallucinations)"
echo
echo "Recommended models (no corporate censorship):"
echo "  - Dolphin 3.0 (most unrestricted, best reasoning)"
echo "  - Hermes 2 (factual, instruction-following)"
echo "  - Mistral (balanced, neutral)"
echo
echo "For more details, see README.md"
echo
