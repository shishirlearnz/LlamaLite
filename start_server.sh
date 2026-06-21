#!/bin/bash

# 1. Ensure an argument was provided
if [ -z "$1" ]; then
    echo "❌ Error: No model path provided."
    echo "Usage: ./start_server.sh /path/to/your_model.gguf"
    exit 1
fi

MODEL_PATH="$1"

# 2. Ensure the provided file actually exists
if [ ! -f "$MODEL_PATH" ]; then
    echo "❌ Error: Model file not found at '$MODEL_PATH'"
    echo "Please check the spelling or path and try again."
    exit 1
fi

LLAMA_SERVER_BIN="./llama.cpp/build/bin/llama-server"
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