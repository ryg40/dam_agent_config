---
title: vLLM Launch Command with Tensor Parallelism
type: snippet
project: homelab-inference
tags: [snippet, vllm, gpu, tensor-parallel]
created: 2026-04-30T16:00:00-04:00
status: active
source: agent
session_id: opc-2026-04-30-002
source_daily: "[[2026-04-30]]"
confidence: 9
---

# vLLM Launch Command with Tensor Parallelism

Working command for Llama 3.3 70B on dual GPU setup.

## Command

```bash
CUDA_VISIBLE_DEVICES=0,1 python -m vllm.entrypoints.openai.api_server \
  --model meta-llama/Llama-3.3-70B-Instruct \
  --tensor-parallel-size 2 \
  --gpu-memory-utilization 0.95 \
  --max-model-len 8192 \
  --port 8000 \
  --host 0.0.0.0
```

## Key Parameters

| Parameter | Value | Notes |
|-----------|-------|-------|
| `--tensor-parallel-size` | 2 | Number of GPUs |
| `--gpu-memory-utilization` | 0.95 | Max VRAM usage |
| `--max-model-len` | 8192 | Context window |

## Environment

```bash
export CUDA_VISIBLE_DEVICES=0,1
export VLLM_WORKER_MULTIPROC_METHOD=spawn
```

## Caveats

- GPUs must have same compute capability
- Mixed VRAM sizes: limited to smallest GPU
- Requires NCCL for GPU communication

## Related

- [[../concepts/concept-tensor-parallelism]]
- [[../concepts/concept-cuda-device-ordering]]
