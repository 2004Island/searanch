---
title: "PyTorch"
weight: 2
bookCollapseSection: false
---

# PyTorch on AMD GPUs

Guides for running PyTorch with ROCm on AMD GPUs.

## Topics

- **Installation** - Installing PyTorch with ROCm support
- **Migration from CUDA** - Adapting CUDA code for ROCm
- **Training** - Training models on AMD GPUs
- **Performance** - Optimization tips and benchmarks

## Quick Install

```bash
# PyTorch with ROCm 6.x
pip install torch torchvision torchaudio --index-url https://download.pytorch.org/whl/rocm6.0
```

## Verify Installation

```python
import torch
print(f"PyTorch version: {torch.__version__}")
print(f"ROCm available: {torch.cuda.is_available()}")
print(f"GPU: {torch.cuda.get_device_name(0)}")
```
