#!/data/data/com.termux/files/usr/bin/bash

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

MODELS_DIR="$HOME/models"

# Create models directory if it doesn't exist
mkdir -p "$MODELS_DIR"

# ============================================
# COMMANDS
# ============================================

case "${1:-help}" in
    list)
        echo -e "${BLUE}=== Available GGUF Models ===${NC}"
        echo
        
        if [ ! "$(ls -A "$MODELS_DIR")" ]; then
            echo "No models found in $MODELS_DIR"
            echo
            echo "Download a model (7B = best for phones):"
            echo
            echo "Uncensored/Unfiltered options:"
            echo "  1. Dolphin 3.0 (RECOMMENDED - most unrestricted)"
            echo "     https://huggingface.co/cognitivecomputations/dolphin-3.0-mistral-7b-gguf"
            echo
            echo "  2. Hermes 2 (Factual, instruction-following)"
            echo "     https://huggingface.co/TheBloke/Hermes-2-Mistral-7B-GGUF"
            echo
            echo "  3. Mistral 7B (Neutral, fast)"
            echo "     https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF"
            echo
            echo "  4. Llama 2 7B (Open-source, unfiltered)"
            echo "     https://huggingface.co/TheBloke/Llama-2-7B-Chat-GGUF"
            echo
            echo "  5. Neural Chat 7B (Unfiltered conversation)"
            echo "     https://huggingface.co/TheBloke/neural-chat-7B-v3-3-GGUF"
            echo
            echo "Steps:"
            echo "  1. Click a link above"
            echo "  2. Download the -Q4_K_M.gguf or -Q5_K_M.gguf variant"
            echo "  3. Move to: $MODELS_DIR/"
            echo "  4. Run: ./start.sh"
            exit 0
        fi
        
        echo "Models in $MODELS_DIR:"
        echo
        ls -lh "$MODELS_DIR" | tail -n +2 | awk '{printf "  %s (%s)\n", $9, $5}'
        echo
        ;;

    switch)
        if [ -z "$2" ]; then
            error "Usage: ./models.sh switch <model_filename>"
        fi
        
        if [ ! -f "$MODELS_DIR/$2" ]; then
            error "Model not found: $MODELS_DIR/$2"
        fi
        
        success "Will switch to model: $2"
        echo
        echo "Run with:"
        echo "  MODEL_PATH=\"$MODELS_DIR/$2\" ./start.sh"
        echo
        ;;

    info)
        if [ -z "$2" ]; then
            error "Usage: ./models.sh info <model_filename>"
        fi
        
        MODEL="$MODELS_DIR/$2"
        
        if [ ! -f "$MODEL" ]; then
            error "Model not found: $MODEL"
        fi
        
        FILE_SIZE=$(du -h "$MODEL" | cut -f1)
        
        echo -e "${BLUE}=== Model Information ===${NC}"
        echo
        echo "Filename: $2"
        echo "Path: $MODEL"
        echo "Size: $FILE_SIZE"
        echo
        echo "Recommended settings:"
        echo "  - Context size: 4096 tokens (reduce to 2048 if slow)"
        echo "  - Threads: 2-4 (match your CPU cores)"
        echo "  - Temperature: 0.0 (for factual, no hallucinations)"
        echo
        echo "Estimated memory: ~${FILE_SIZE} + 512MB-2GB for runtime"
        echo
        echo "Run:"
        echo "  MODEL_PATH=\"$MODEL\" ./start.sh"
        echo
        ;;

    delete)
        if [ -z "$2" ]; then
            error "Usage: ./models.sh delete <model_filename>"
        fi
        
        if [ ! -f "$MODELS_DIR/$2" ]; then
            error "Model not found: $MODELS_DIR/$2"
        fi
        
        rm -i "$MODELS_DIR/$2"
        success "Model deleted"
        ;;

    download)
        echo -e "${BLUE}=== Model Download Helper ===${NC}"
        echo
        echo "Automatic downloads not yet implemented."
        echo "Please download manually from HuggingFace:"
        echo
        echo "Best uncensored models:"
        echo
        echo "1. Dolphin 3.0 Mistral 7B (RECOMMENDED)"
        echo "   https://huggingface.co/cognitivecomputations/dolphin-3.0-mistral-7b-gguf"
        echo
        echo "2. Hermes 2 Mistral 7B"
        echo "   https://huggingface.co/TheBloke/Hermes-2-Mistral-7B-GGUF"
        echo
        echo "3. Mistral 7B Instruct"
        echo "   https://huggingface.co/TheBloke/Mistral-7B-Instruct-v0.2-GGUF"
        echo
        echo "Steps:"
        echo "  1. Click the link"
        echo "  2. Download variant ending in: -Q4_K_M.gguf or -Q5_K_M.gguf"
        echo "  3. Save to: $MODELS_DIR/"
        echo "  4. Run: ./start.sh"
        echo
        echo "Or via curl (from Linux/Mac):"
        echo "  cd $MODELS_DIR"
        echo "  curl -LO https://huggingface.co/cognitivecomputations/dolphin-3.0-mistral-7b-gguf/resolve/main/dolphin-3.0-mistral-7b.Q4_K_M.gguf"
        echo
        ;;

    clean)
        echo -e "${YELLOW}Cleanup options:${NC}"
        echo
        echo "Nothing to clean right now."
        echo
        echo "Models directory:"
        echo "  $MODELS_DIR"
        echo "  Size: $(du -sh "$MODELS_DIR" | cut -f1)"
        echo
        ;;

    help|--help|-h|"")
        echo -e "${BLUE}=== Bo_AI Model Management ===${NC}"
        echo
        echo "Usage: ./models.sh <command> [options]"
        echo
        echo "Commands:"
        echo
        echo "  list              List all downloaded models"
        echo "  info <filename>   Show model details"
        echo "  switch <filename> Show command to switch models"
        echo "  download          Show download links for recommended models"
        echo "  delete <filename> Delete a model"
        echo "  clean             Show cleanup info"
        echo "  help              This message"
        echo
        echo "Examples:"
        echo
        echo "  ./models.sh list"
        echo "  ./models.sh info dolphin-3.0.gguf"
        echo "  ./models.sh download"
        echo "  MODEL_PATH=\"\$HOME/models/dolphin-3.0.gguf\" ./start.sh"
        echo
        echo "Recommended uncensored models (no corporate safety censorship):"
        echo "  - Dolphin 3.0 (most unrestricted, excellent reasoning)"
        echo "  - Hermes 2 (factual, instruction-following)"
        echo "  - Mistral (balanced, neutral)"
        echo "  - Llama 2 (open-source, no filtering)"
        echo
        ;;

    *)
        error "Unknown command: $1. Use './models.sh help' for usage."
        ;;
esac
