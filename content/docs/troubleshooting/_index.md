---
title: "Troubleshooting"
weight: 10
bookCollapseSection: false
---

# Troubleshooting AMD GPU + AI Issues

Common problems and solutions when running AI workloads on AMD GPUs.

## Common Issues

### GPU Not Detected

```bash
# Check if GPU is visible
rocm-smi

# Check ROCm installation
rocminfo
```

### Permission Denied

Add your user to the `render` and `video` groups:

```bash
sudo usermod -a -G render,video $USER
# Log out and back in
```

### Out of Memory

- Reduce batch size
- Use gradient checkpointing
- Try smaller model variants
- Enable memory-efficient attention

### Performance Issues

- Ensure ROCm drivers match PyTorch ROCm version
- Check `HSA_OVERRIDE_GFX_VERSION` for unsupported GPUs
- Monitor with `rocm-smi` during inference
