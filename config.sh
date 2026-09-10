#!/data/data/com.termux/files/usr/bin/bash
# Bo_AI Configuration File
# Customize these settings to optimize performance on your device

# ============================================
# Model Settings
# ============================================

# Path to your GGUF model file
# Recommended uncensored models (no corporate safety censorship):
#   - Dolphin 3.0 (most unrestricted, excellent reasoning)
#   - Hermes 2 (factual, instruction-following)
#   - Mistral (balanced, neutral outputs)
#   - Llama 2 (open-source, no safety filtering)
#   - Neural Chat (unfiltered conversation)
MODEL_PATH="$HOME/models/model.gguf"

# ============================================
# Server Settings
# ============================================

# Bind address (127.0.0.1 = local only, secure)
# Use 0.0.0.0 to allow network access (WARNING: exposes API to LAN)
HOST="127.0.0.1"

# Server port
PORT="8080"

# ============================================
# Performance Tuning
# ============================================

# Context window size (tokens the model can "see")
# Higher = better reasoning but more memory/slower
#   2048  = minimal (phones with < 2GB RAM)
#   4096  = balanced (default, good for most phones)
#   8192  = better reasoning (8GB+ RAM phones)
# Test with your phone:
#   - If server crashes: reduce this
#   - If responses are slow: reduce this
#   - If answers lack context: increase this
CTX_SIZE="4096"

# CPU threads (set to your phone's core count)
# Check with: grep processor /proc/cpuinfo | wc -l
# Common values: 2, 4, 6, 8
#   2 = conservative, won't max out phone
#   4 = balanced
#   6+ = aggressive, may cause heat/throttling
THREADS="2"

# GPU acceleration (Mali/Adreno GPUs)
# Most phones: 0 (disabled)
# If your phone has a dedicated GPU and llama.cpp supports it: try 10-20
GPU_LAYERS="0"

# ============================================
# Quality Settings (for accuracy)
# ============================================

# Temperature in test.sh (0.0 = deterministic, no hallucinations)
# Set in Chatbox to match if needed
#   0.0  = factual, no randomness (recommended for raw truth)
#   0.3  = slightly creative
#   0.7  = more creative
# Keep at 0.0 to minimize logical hallucinations
TEMPERATURE="0.0"

# ============================================
# Logging & Debugging
# ============================================

# Enable verbose logging (true/false)
VERBOSE="false"

# Log file path (optional)
# LOG_FILE="$HOME/bo_ai.log"

# ============================================
# Advanced Settings (rarely needed)
# ============================================

# Maximum tokens per response
MAX_TOKENS="2048"

# Timeout for requests (seconds)
TIMEOUT="300"

# ============================================
# Quick Start Commands
# ============================================

# Run like this:
#   source config.sh && ./start.sh
#
# Or override individual settings:
#   CTX_SIZE="2048" THREADS="4" ./start.sh
#
# Or manually:
#   MODEL_PATH="$HOME/models/dolphin-3.0.gguf" CTX_SIZE="8192" ./start.sh
