#!/bin/bash

# Ensure a model path is provided as an argument
if [ -z "$1" ]; then
    echo "❌ Error: Please provide the path to your .gguf model."
    echo "Usage: ./start_server.sh /path/to/your_model.gguf"
    exit 1
fi

MODEL_PATH="$1"
LLAMA_SERVER_BIN="../llama.cpp/build/bin/llama-server"
PORT=8080
CTX_SIZE=2048

echo "🚀 Starting LlamaLite Server..."
echo "Attempting Metal GPU acceleration (15 layers)..."

# Run the primary command
$LLAMA_SERVER_BIN -m "$MODEL_PATH" --port $PORT -c $CTX_SIZE -ngl 15

# Capture the exact exit code of the server
EXIT_CODE=$?

# If the user intentionally stopped the server with Ctrl+C, exit cleanly.
if [ $EXIT_CODE -eq 130 ]; then
    echo "🛑 Server gracefully stopped by user."
    exit 0
fi

# If the server crashed (e.g., Out of Memory on an 8GB machine), trigger the fallback.
if [ $EXIT_CODE -ne 0 ]; then
    echo "⚠️ GPU server crashed (Exit code: $EXIT_CODE). Likely Out of Memory."
    echo "🔄 FALLBACK: Restarting server strictly on CPU (-ngl 0)..."
    
    $LLAMA_SERVER_BIN -m "$MODEL_PATH" --port $PORT -c $CTX_SIZE -ngl 0
fi