# vLLM runtime config

OpenAI-compatible vLLM server for the **executor** slot in the orchestrator/executor
split. Tuned for a 2-GPU Blackwell (SM120) host with ~72 GB total VRAM.

## Files

| File | Purpose |
|------|---------|
| `docker-compose.yml` | Service definition. Reads secrets from `.env`. |
| `.env.example` | Template for the gitignored `.env`. |

## Setup

```bash
cp .env.example .env
# edit .env, set HF_TOKEN to your Hugging Face token
docker network create --subnet 172.30.0.0/16 llama-vllm-shared  # once
docker compose up -d
```

The server listens on `http://localhost:8001/v1` (OpenAI-compatible).
Inside the `llama-vllm-shared` network it is reachable at `172.30.0.21:8000`.

## What this config does

- **Model:** `llmfan46/Qwen3.6-27B-uncensored-heretic-v2-Native-MTP-Preserved-NVFP4`
  served as `qwen3.6-27b`.
- **Tensor parallel** across 2 GPUs (`CUDA_VISIBLE_DEVICES=0,1`, `--tensor-parallel-size 2`).
- **120k context** with FP8 KV cache and prefix caching for high cache reuse on the
  orchestrator's slowly-changing prompt.
- **Speculative decoding** via Qwen3.5 MTP (3 draft tokens) for throughput.
- **Tool calling** with `qwen3_coder` parser; reasoning traces parsed by `qwen3`.
- **SM120 TMA patch** applied at container start so vLLM's FLA ops accept
  Blackwell capability `12.x` (upstream guard rejects `>= 9`).
- **Language-model-only**, multimodal disabled (`--limit-mm-per-prompt` zeros).

## Sensitive values

Only `HF_TOKEN` is sensitive today. It comes from `.env` (gitignored). If you add
more secrets (S3 keys, proxy creds, etc.) put them in `.env` too — never inline
them in `docker-compose.yml`.

If a token has ever been pasted into a chat, a commit message, or a screenshot:
**rotate it**. Treat it as compromised.
