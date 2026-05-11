# Runtime configs

Reference docker-compose stacks for the two model servers this repo's agent
config is tuned against. Both implement the OpenAI-compatible API so any client
that points at `OPENAI_BASE_URL` works.

| Stack | Role | Default port | Path |
|-------|------|--------------|------|
| llama-server (via llama-swap) | orchestrator / planner | `9292` | [`llama-server/`](llama-server/) |
| vLLM | executor / heavy generation | `8001` | [`vllm/`](vllm/) |

Both attach to an external `llama-vllm-shared` docker network so they can call
each other on `172.30.0.0/16` without going through the host. Create the
network once before bringing either stack up:

```bash
docker network create --subnet 172.30.0.0/16 llama-vllm-shared
```

## Secrets

Each stack reads sensitive values from a local `.env` file that is **gitignored**
(`configs/**/.env` in [`.gitignore`](../.gitignore)). The committed `.env.example`
files document every variable.

- Never inline tokens (e.g. `HF_TOKEN`) in `docker-compose.yml`.
- Never paste a real token into chat, a commit message, or a screenshot.
- If a token has been exposed anywhere, **rotate it** — treat it as compromised.
- The orchestrator/executor topology means tokens often get loaded into long-lived
  containers; rotation costs nothing and is the right reflex.

## Why two servers, not one

The orchestrator/executor split (see [`AGENTS.md`](../AGENTS.md)) wants
different things from each slot:

- **Orchestrator** changes prompt slowly, benefits from prefix caching and
  fast model swaps. llama-swap + GGUF + llama-server fits.
- **Executor** runs one heavy task at a time over a 100k+ context with tool
  calls. vLLM with tensor-parallel, FP8 KV, and speculative decoding fits.

You can collapse to a single backend in either direction; the agent config
does not care, as long as both endpoints speak OpenAI-compatible HTTP.
