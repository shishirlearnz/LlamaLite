# LlamaLite 🦙🚀

A minimal, lightning-fast open-source repository showcasing how to build a local, privacy-first AI application using `llama.cpp` as the backend engine and Python as the client interface.

Optimized specifically for hardware with limited VRAM/RAM (such as 8GB M-series Macs) with **built-in hardware resilience and auto-fallback mechanisms**. Fully compatible with Linux and macOS.

---

## Prerequisites

- Python 3.9+ (On Debian/Ubuntu Linux, ensure `python3-venv` is installed)
- CMake (for building the backend engine)
- A GGUF format model optimized for 8GB RAM (e.g., `Llama-3.2-3B-Instruct-Q8_0.gguf`)
  - *Note: This specific 3B model and 8-bit quantization was chosen because it fits comfortably within 8GB of unified memory, preventing the out-of-memory crashes and severe disk-swapping bottlenecks typically seen with larger 8B models on constrained hardware.*

---

## Setup Instructions

### 1. Clone the Repository
First, clone this repository (LlamaLite) to your local machine. This is the main project you'll be working with:

```bash
git clone git@github.com:shishirlearnz/LlamaLite.git
cd LlamaLite
```

### 2. Build the Backend Engine
LlamaLite depends on `llama.cpp` as its backend engine. Clone and build the server binaries (this is a separate repository that LlamaLite uses internally):

```bash
git clone git@github.com:ggml-org/llama.cpp.git
cd llama.cpp
cmake -B build
cmake --build build --config Release
cd ..
```

### 3. Set Up the Python Environment
To keep your computer's system files clean, we use a **Virtual Environment**. This creates an isolated "sandbox" for this project, ensuring that our Python dependencies don't conflict with other software on your machine and preventing "permission denied" errors when installing packages.

```bash
# 1. Create the sandbox (creates a folder named '.venv')
python3 -m venv .venv

# 2. Activate the sandbox (locks your terminal into this project)
source .venv/bin/activate

# 3. Install project dependencies into the sandbox
pip install -r requirements.txt
```

---

## How to Run

### Step 1: Start the Server
Run the startup script by passing the path to your local model file. It automatically attempts GPU acceleration and falls back to CPU if memory is saturated.

```bash
chmod +x start_server.sh
./start_server.sh <PATH_TO_YOUR_MODEL.gguf>

# Example using a verified 8GB-compatible model:
# ./start_server.sh ~/Downloads/Llama-3.2-3B-Instruct-Q8_0.gguf
```

### Step 2: Query the Model
Open a new terminal window, activate your environment, and query the model:

```bash
source .venv/bin/activate
python app.py "What is the difference between compiling and interpreting code?"
```

---

## Fallback Mechanisms Explained

- **Hardware & Model Sizing Context:** On an 8GB machine, large models (like 8B parameters) will saturate unified memory, causing extreme slowdowns (swapping) or outright crashes. This project is verified to run smoothly with 3B parameter models using 8-bit quantization.
- **Server Auto-Fallback (`start_server.sh`):** If a model is too large for your GPU memory, the script intercepts the crash signal during startup. If triggered, it automatically overrides the configuration and restarts the model using `-ngl 0` (CPU processing only) to prioritize stability over speed.
- **CLI Fallback (`app.py`):** If the API server is offline or unreachable, the Python application intercepts the connection error and outputs a fully structured copy-paste friendly terminal command to run the prompt directly via the native `llama-cli`.

---

## License

This project is open-source software licensed under the terms of the **MIT License**.
