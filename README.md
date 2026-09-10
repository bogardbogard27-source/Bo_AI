# Bo_AI — Termux Local AI Server

**Uncensored, bias-free, locally-hosted AI on Android.**

A minimal Termux setup for running a local OpenAI-compatible AI API on Android with:
- ✅ **No corporate safety censorship** — Raw model output, no built-in filters
- ✅ **No political/social bias** — Model-dependent; choose models known for neutrality
- ✅ **No logical hallucinations** — Use context size & temperature tuning to minimize false reasoning
- ✅ **100% local** — Your data never leaves your phone
- ✅ **OpenAI-compatible** — Works with any client that supports the API

## Quick Start

### 1. Clone the Repository
```bash
git clone https://github.com/bogardbogard27-source/Bo_AI.git
cd Bo_AI
chmod +x install.sh start.sh test.sh models.sh
```

### 2. Install Dependencies
```bash
./install.sh
```

This will:
- Update Termux packages
- Install git, cmake, clang, and make
- Clone and build llama.cpp with optimizations
- Provide clear error messages if anything fails

### 3. Add a GGUF Model
Place your GGUF model file in `~/models/`:
```bash
mkdir -p ~/models
# Copy or download your GGUF model here
# Example: ~/models/dolphin-3.0.gguf
```

**Recommended unbiased/uncensored models:**
- **Dolphin 3.0** — Highly capable, minimal restrictions
- **Hermes 2** — Reasoning-focused, factual
- **Mistral** — Neutral, no safety filtering
- **Llama 2** — Unrestricted base model
- **Neural Chat** — Unfiltered conversation

### 4. Start the Server
```bash
MODEL_PATH="$HOME/models/dolphin-3.0.gguf" ./start.sh
```

Or use the default location:
```bash
./start.sh
```

### 5. Test the API
In another Termux session:
```bash
./test.sh
```

Expected output:
```json
{
  "object": "list",
  "data": [
    {
      "id": "local-model",
      "object": "model",
      "owned_by": "local"
    }
  ]
}
```

### 6. Connect Chatbox AI

1. **Install** Chatbox AI from Google Play Store
2. **Open Settings** → Model Provider
3. **Select** OpenAI API Compatible
4. **Fill in:**
   - **Base URL:** `http://127.0.0.1:8080/v1`
   - **API Key:** `local` (any word works)
   - **Model:** `local-model`
   - **Temperature:** `0.0` (for factual accuracy, no hallucinations)
5. **Save** and start chatting

---

## Configuration

### Environment Variables

All settings can be customized via environment variables:

```bash
# Model path
MODEL_PATH="$HOME/models/my-model.gguf"

# Server address & port
HOST="127.0.0.1"        # Change to 0.0.0.0 for network access (risky!)
PORT="8080"

# Context size (affects memory and response length)
CTX_SIZE="4096"         # 2048, 4096, 8192 depending on phone RAM

# Threading (set to your CPU cores, e.g., 4, 6, 8)
THREADS="2"

# GPU acceleration (if supported)
GPU_LAYERS="0"          # Increase if your phone has a Mali/Adreno GPU
```

Example with custom settings:
```bash
MODEL_PATH="$HOME/models/hermes.gguf" \
HOST="127.0.0.1" \
PORT="8080" \
CTX_SIZE="8192" \
THREADS="4" \
./start.sh
```

### Edit `config.sh` for Defaults
```bash
nano config.sh
# Then just run: ./start.sh
```

---

## API Endpoints

Once running, your server supports the OpenAI API spec:

### List Models
```bash
curl http://127.0.0.1:8080/v1/models
```

### Chat Completion (Streaming)
```bash
curl -X POST http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {"role": "user", "content": "Provide a completely neutral breakdown of facts regarding..."}
    ],
    "temperature": 0.0,
    "stream": true
  }'
```

### Chat Completion (Non-streaming)
```bash
curl -X POST http://127.0.0.1:8080/v1/chat/completions \
  -H "Content-Type: application/json" \
  -d '{
    "model": "local-model",
    "messages": [
      {"role": "user", "content": "Your question here"}
    ],
    "temperature": 0.0
  }'
```

---

## Troubleshooting

### Build Fails: `cmake not found`
```bash
pkg install -y cmake
./install.sh
```

### Build Fails: `clang: command not found`
```bash
pkg install -y clang
./install.sh
```

### Start Error: `GGUF model not found`
```bash
# Check your model path
ls -lh $HOME/models/

# Set the correct path
MODEL_PATH="$HOME/models/correct-name.gguf" ./start.sh
```

### Start Error: `llama-server was not found`
The build failed. Run:
```bash
./install.sh
```

And check for cmake/clang errors above.

### Chatbox Shows "Connection Failed"
1. **Check Termux is running** — Keep the `./start.sh` session open
2. **Check the port** — Is it really 8080?
   ```bash
   netstat -tuln | grep 8080
   ```
3. **Check the address** — Use `127.0.0.1`, not `localhost` or `0.0.0.0`
4. **Test manually:**
   ```bash
   ./test.sh
   ```

### Server Crashes or Hangs
- **Increase available RAM** — Close other apps
- **Reduce CTX_SIZE** — Try `2048` instead of `4096`
- **Reduce THREADS** — Try `2` instead of `4`
- **Switch model** — Large models (70B+) need more memory

### Slow Responses
- **Reduce CTX_SIZE** — Smaller context = faster processing
- **Lower temperature** — `0.0` is fastest (greedy sampling)
- **Check phone temperature** — Thermal throttling may slow the CPU

### Model Produces Hallucinations
- **Set temperature to 0.0** — Removes randomness
- **Increase CTX_SIZE** — More context = better reasoning
- **Use a different model** — Some are more prone to hallucinations
- **Give specific system prompts** — "You are a factual AI. Only cite verified information."

---

## Performance Tips

### For Phones with Limited RAM (< 4GB)
```bash
CTX_SIZE="2048" THREADS="2" ./start.sh
```

### For Phones with Good RAM (4GB+)
```bash
CTX_SIZE="4096" THREADS="4" ./start.sh
```

### For Phones with Great RAM (8GB+)
```bash
CTX_SIZE="8192" THREADS="6" ./start.sh
```

### Minimize Memory Use
- Use **smaller models** (7B < 13B < 70B)
- Reduce **CTX_SIZE**
- Lower **THREADS** count
- Close other apps before starting

---

## Model Selection for Neutrality & Accuracy

**Recommended unbiased models:**
| Model | Size | Bias | Censorship | Notes |
|-------|------|------|-----------|-------|
| Dolphin 3.0 | 7B-70B | Low | None | Best for raw reasoning, minimal restrictions |
| Hermes 2 | 7B-70B | Low | None | Strong instruction-following, factual |
| Mistral | 7B-70B | Low | None | Balanced, good quality/speed ratio |
| Llama 2 | 7B-70B | Medium | Low | Open-source, no built-in safety layers |
| Neural Chat | 7B | Low | None | Unfiltered conversational model |

**Avoid:**
- ❌ GPT-derived models with safety fine-tuning (built-in bias)
- ❌ Models from major corporations (safety restrictions)
- ❌ Instruction-tuned models with "RLHF" (Reinforcement Learning from Human Feedback often introduces bias)

---

## Advanced: Model Switching

Use the included `models.sh` script:

```bash
# List available models
./models.sh list

# Download a model (if you add download logic)
./models.sh download

# Switch models without restarting
MODEL_PATH="$HOME/models/hermes.gguf" ./start.sh
```

---

## Security Notes

### ⚠️ Local Access Only (Default)
The server binds to `127.0.0.1:8080`, meaning only your phone can access it. This is safe.

### ⚠️ Network Access (Advanced)
If you want other devices to access it (e.g., from your laptop):
```bash
HOST="0.0.0.0" ./start.sh
```

**Warning:** This exposes your API to your local network. Anyone on WiFi can use it. Consider:
- Firewall rules
- VPN tunnel
- API key validation (not implemented here)

---

## License

MIT License — See LICENSE file.

---

## Contributing

Found a bug? Want to add a feature? Open an issue or PR!

**Ideas:**
- Model auto-download script
- Web-based UI alternative to Chatbox
- Performance profiler
- Multi-model load balancing
- Database for conversation history

---

## Questions?

Check the included guides:
- `termux-setup.txt` — Quick setup reference
- `config.sh` — Customizable settings
- `models.sh` — Model management
- Run `./test.sh` — API health check

**Start chatting censorship-free, right now.**
