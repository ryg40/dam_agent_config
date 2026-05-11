# llama-server (via llama-swap) runtime config

[`llama-swap`](https://github.com/mostlygeek/llama-swap) fronts one or more
`llama-server` (llama.cpp) instances and hot-swaps GGUF models on demand.
This is the **orchestrator** slot in the orchestrator/executor split — small
context turnover, frequent prompt reuse, MoE-friendly.

## Files

| Path | Purpose |
|------|---------|
| `docker-compose.yml` | Service definition. Reads paths/secrets from `.env`. |
| `.env.example` | Template for the gitignored `.env`. |
| `config/config.yaml` | llama-swap model definitions. Reference set, edit per host. |

## Setup

```bash
cp .env.example .env
# edit .env if your HF cache or llama.cpp checkout live in non-default paths
# edit config/config.yaml to match the GGUFs and llama.cpp build on this host
docker network create --subnet 172.30.0.0/16 llama-vllm-shared  # once, shared with vllm
docker compose up -d
```

### Shipped `config/config.yaml`

Defines two Qwen3.6-35B-A3B variants that share the same in-container
`llama-server` on port `9876`, swapped on demand by llama-swap:

| Model ID | GGUF | Context |
|----------|------|---------|
| `Qwen3.6-35B-Q8` | `/data/Qwen_Qwen3.6-35B-A3B-Q8_0.gguf` | 140k |
| `Qwen3.6-35B-Apex-Bal` | `/data/Qwen3.6-35B-A3B-APEX-I-Balanced.gguf` | 172k |

Both run flash-attention (`-fa on`), Qwen3 sampling defaults (`temp 0.6 / top-p 0.95 / top-k 20`),
4096 batch/ubatch, `--jinja` chat templating, and `--reasoning-format auto`. The
`healthCheckTimeout: 1500` at the top gives slow GGUF loads up to 25 minutes
before llama-swap marks the model unhealthy. Macros at the top of the file
demonstrate the multi-line and nested-macro syntax — see
[llama-swap config docs](https://github.com/mostlygeek/llama-swap#configuration)
for the full schema.

Add new models by appending entries under `models:` with a unique key (used as
the model ID in OpenAI-compatible requests) and a `cmd` that launches
`llama-server` against the right GGUF.

The router listens on `http://localhost:9292` (OpenAI-compatible).
Inside the `llama-vllm-shared` network it is reachable at `172.30.0.20:8080`.

## What this config does

- **Image:** `ghcr.io/mostlygeek/llama-swap:cuda` (swap to `:vulkan` or `:cpu`
  variants for non-NVIDIA hosts).
- **GPUs 0 and 3 only** via `device_ids: "0,3"`. Edit to match your topology.
  vLLM (in `../vllm/`) takes GPUs 1 and 2 in the canonical layout, so the two
  stacks coexist on a 4-GPU host.
- **Read-only mounts** for the HF cache and a `llama.cpp` checkout, so the
  container can load any GGUF you have downloaded and use any local
  `llama-server` build without rebuilding the image.
- **Shared external network** with vLLM so an orchestrator running here can
  call the executor over the internal `172.30.0.0/16` subnet without
  hairpinning through the host.

## Sensitive values

`HF_TOKEN` is the only secret today, and only matters if your `config.yaml`
references gated or private models. Everything else in `.env` is just a
host-path override. Real `.env` is gitignored.

If a token has ever been pasted into a chat, a commit message, or a screenshot:
**rotate it**. Treat it as compromised.
