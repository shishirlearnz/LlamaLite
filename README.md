# LlamaLite 🦙🚀

A minimal, lightning-fast open-source repository showcasing how to build a local, privacy-first AI application using `llama.cpp` as the backend engine and Python as the client interface.

Optimized specifically for hardware with limited VRAM/RAM (such as 8GB M-series Macs) with **built-in hardware resilience and auto-fallback mechanisms**. Fully compatible with Linux and macOS.

---

## Setup Instructions

### 1. Build the Backend Engine
Clone and build the server binaries via SSH:

```bash
git clone git@github.com:ggml-org/llama.cpp.git
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ..
```

### 2. Set Up the Python Environment
We use an isolated virtual environment to ensure dependency compatibility across operating systems. Inside your `LlamaLite` directory, run:

```bash
# 1. Create and activate the virtual environment
python3 -m venv venv
source venv/bin/activate

# 2. Install dependencies (automatically handles macOS compatibility)
pip install -r requirements.txt
```

---

## How to Run

### Step 1: Start the Server
Run the startup script by passing the path to your local model file. It automatically attempts GPU acceleration and falls back to CPU if memory is saturated.

```bash
chmod +x start_server.sh
./start_server.sh /path/to/your_model.gguf
```

### Step 2: Query the Model
Open a new terminal window, activate your environment, and query the model:

```bash
source venv/bin/activate
python app.py "What is the difference between compiling and interpreting code?"
```

---

## License

This project is open-source software licensed under the terms of the **MIT License**.