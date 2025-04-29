#!/usr/bin/env bash

set -e
echo "🚀 Starting container setup..."

# Auth HuggingFace if token provided
if [[ -n "$HF_TOKEN" ]]; then
  echo "🔐 Authenticating with Hugging Face"
  huggingface-cli login --token "$HF_TOKEN" --add-to-git-credential
fi

# === Conditional Model Setup ===

# Flux
if [[ "$DOWNLOAD_FLUX" == "true" ]]; then
  echo "📥 Downloading Flux model and components..."
  if [ ! -d "/workspace/models/flux" ]; then
    git clone https://huggingface.co/blackforest-ai/fluxgym /workspace/models/flux
  else
    echo "⚠️ Flux model already exists, skipping..."
  fi
fi

# HiDream
if [[ "$DOWNLOAD_HIDREAM" == "true" ]]; then
  echo "📥 Downloading HiDream..."
  mkdir -p /workspace/models/hidream
  wget -nc -O /workspace/models/hidream/hidream_i1_dev_bf16.safetensors \
    https://huggingface.co/Comfy-Org/HiDream-I1_ComfyUI/resolve/main/split_files/diffusion_models/hidream_i1_dev_bf16.safetensors
fi

# WAN 2.1
if [[ "$DOWNLOAD_WAN" == "true" ]]; then
  echo "📥 Downloading WAN 2.1 T2I..."
  if [ ! -d "/workspace/models/wan" ]; then
    git clone https://huggingface.co/Wan-AI/Wan2.1-T2V-14B /workspace/models/wan
  else
    echo "⚠️ WAN model already exists, skipping..."
  fi
fi

# === Training Placeholder ===
echo "✅ Environment setup complete."
echo "You can now run training commands inside the container."

exec "$@"

