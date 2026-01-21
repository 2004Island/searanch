---
title: "Image Generation"
weight: 4
bookCollapseSection: false
---

# Image Generation on AMD GPUs

Guides for running Stable Diffusion and other image generation tools on AMD GPUs.

## Tools Covered

- **AUTOMATIC1111** - Popular Stable Diffusion web UI
- **ComfyUI** - Node-based workflow for image generation
- **Stable Diffusion WebUI Forge** - Optimized SD interface
- **Fooocus** - Simplified Midjourney-style interface

## Performance Notes

AMD GPUs work well for image generation with some considerations:
- Use PyTorch with ROCm for best compatibility
- Some optimizations (like xformers) have AMD-specific versions
- SDXL and newer models run well on 16GB+ VRAM cards
