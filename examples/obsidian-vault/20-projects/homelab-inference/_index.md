---
title: Homelab Inference Stack
type: project
tags: [homelab, inference, vllm, gpu, project]
created: 2026-04-15T10:00:00-04:00
status: active
---

# Homelab Inference Stack

Project MOC for local LLM inference infrastructure.

## Overview

Self-hosted inference stack on Proxmox:
- **GPUs**: RTX 3090 (24GB) + A6000 (48GB)
- **Runtime**: vLLM with tensor parallelism
- **Frontend**: llama-swap for model switching
- **Proxy**: Caddy reverse proxy with SSL

## Active Work

```dataview
TASK
FROM "20-projects/homelab-inference"
WHERE !completed
```

## Recent Decisions

```dataview
TABLE title, created, confidence
FROM "20-projects/homelab-inference/decisions"
SORT created DESC
LIMIT 5
```

## Key Concepts

- [[concept-tensor-parallelism]] — Splitting models across GPUs
- [[concept-cuda-device-ordering]] — GPU visibility and ordering
- [[concept-vram-management]] — Memory utilization settings

## Key Snippets

- [[snippet-vllm-launch-command]] — Working vLLM launch with TP
- [[snippet-docker-compose-vllm]] — Docker compose for vLLM

## Hardware

| GPU | VRAM | CUDA Compute |
|-----|------|--------------|
| RTX 3090 | 24GB | 8.6 |
| A6000 | 48GB | 8.6 |

## Links

- [[../opencode-agent/_index|OpenCode Agent Project]]
- [[../../30-areas/ai-tooling/_index|AI Tooling Area]]
