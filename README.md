# LlamaLite 🦙🚀

A minimal, lightning-fast open-source repository showcasing how to build a local, privacy-first AI application using `llama.cpp` as the backend engine and Python as the client interface.

Optimized specifically for hardware with limited VRAM/RAM (such as 8GB M-series Macs) with **built-in hardware resilience and auto-fallback mechanisms**.

---

## Repository Structure

The project consists of the following 5 core files:

* **`README.md`**: Core documentation, setup guidelines, and architectural overview.
* **`LICENSE`**: The open-source MIT License terms governing the use and distribution of this software.
* **`requirements.txt`**: Python package dependencies required for the client application.
* **`start_server.sh`**: A robust bash script that manages backend initialization and catches Out-Of-Memory (OOM) errors to enforce a CPU fallback.
* **`app.py`**: A clean command-line interface (CLI) Python app that acts as an HTTP client to communicate with the local server.

---

## Prerequisites

- Python 3.9+
- CMake (for building the backend engine)
- A GGUF format model (e.g., `Llama3.3-8B-Instruct-Thinking-Heretic-Uncensored-Claude-4.5-Opus-High-Reasoning.i1-Q4_K_M.gguf`)

---

## Setup Instructions

### 1. Build the Backend Engine
Clone and build the server binaries via SSH in a directory adjacent to this project:

```bash
git clone git@github.com:ggml-org/llama.cpp.git
cd llama.cpp
cmake -B build
cmake --build build --config Release
```

### 2. Set Up the Environment
Install the required packages inside your local `LlamaLite` directory:

```bash
pip install -r requirements.txt
```

---

## How to Run

### Step 1: Start the Server (With Auto-Fallback)
Run the provided startup script by passing the path to your local model file. It automatically attempts to utilize GPU acceleration, but seamlessly drops down to CPU-only execution if your system memory is saturated.

```bash
chmod +x start_server.sh
./start_server.sh /path/to/your_model.gguf
```

### Step 2: Query the Model
Open a new terminal window and execute the client script with your prompt:

```bash
python app.py "What is the difference between compiling and interpreting code?"
```

---

## Fallback Mechanisms Explained

- **Server Auto-Fallback (`start_server.sh`):** On 8GB machines, shared unified memory can fill up rapidly. The script intercepts the `kIOGPUCommandBufferCallbackErrorOutOfMemory` crash signal (exit code `!0`) during startup. If triggered, it automatically overrides the configuration and restarts the model using `-ngl 0` (CPU processing only). It ignores standard keyboard interrupts (`Ctrl+C`), allowing for clean manual shutdowns.
- **CLI Fallback (`app.py`):** If the API server is offline or unreachable, the Python application intercepts the connection error and outputs a fully structured copy-paste friendly terminal command to run the prompt directly via the native `llama-cli`.

---

## License

This project is open-source software licensed under the terms of the **MIT License**. See the `LICENSE` file in this repository for full details. Permission is hereby granted to use, modify, copy, and distribute this wrapper without restriction.