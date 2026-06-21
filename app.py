#!/usr/bin/env python3
import sys
import requests

SERVER_URL = "http://localhost:8080/v1/chat/completions"

def query_local_llm(prompt: str):
    """Sends a text prompt to the local llama.cpp server."""
    headers = {"Content-Type": "application/json"}
    
    payload = {
        "messages": [
            {
                "role": "system", 
                "content": "You are a concise, helpful local AI development assistant."
            },
            {
                "role": "user", 
                "content": prompt
            }
        ],
        "temperature": 0.7,
        "max_tokens": 256
    }

    try:
        print("🤖 Thinking...")
        response = requests.post(SERVER_URL, json=payload, headers=headers)
        response.raise_for_status()
        
        result = response.json()
        reply = result["choices"][0]["message"]["content"]
        print("\n📢 Response:")
        print(reply.strip())
        
    except requests.exceptions.ConnectionError:
        print("\n❌ Error: Cannot connect to the local server.")
        print("Please ensure you ran ./start_server.sh first.")
        print("\n🔄 CLI FALLBACK: If you'd rather bypass the server, use this command directly in your terminal:")
        print(f'   ../llama.cpp/build/bin/llama-cli -m <PATH_TO_YOUR_MODEL.gguf> -p "{prompt}" -n 256 -ngl 0')
        sys.exit(1)
    except Exception as e:
        print(f"\n❌ An unexpected error occurred: {e}")
        sys.exit(1)

if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Usage: python app.py \"Your question here\"")
        sys.exit(1)
        
    user_prompt = sys.argv[1]
    query_local_llm(user_prompt)