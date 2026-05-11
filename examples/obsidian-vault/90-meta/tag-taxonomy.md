---
title: Tag Taxonomy
type: meta
tags: [meta, tags]
created: 2026-04-28T10:00:00-04:00
status: active
---

# Tag Taxonomy

Authoritative tag list for the vault. Flat, kebab-case.

## Domain (what is this about)

| Tag | Description |
|-----|-------------|
| `#ai-inference` | LLM inference, vLLM, llama.cpp |
| `#docker` | Containers, Docker Compose |
| `#proxmox` | Proxmox VE, LXC, VMs |
| `#networking` | Network config, DNS, VPN |
| `#storage` | ZFS, NFS, backups |
| `#observability` | Monitoring, logging, metrics |
| `#security` | Auth, certs, hardening |
| `#cicd` | CI/CD pipelines, GitHub Actions |
| `#frontend` | UI, web apps |
| `#backend` | APIs, services |

## Type (what kind of note)

| Tag | Description |
|-----|-------------|
| `#decision` | ADR-style decision record |
| `#snippet` | Reusable code/config |
| `#concept` | Atomic knowledge note |
| `#troubleshoot` | Problem + solution |
| `#postmortem` | Incident analysis |
| `#reference` | External docs, links |
| `#meeting` | Meeting notes |

## Status / Lifecycle

| Tag | Description |
|-----|-------------|
| `#wip` | Work in progress |
| `#blocked` | Blocked by dependency |
| `#done` | Completed |
| `#deprecated` | No longer relevant |

## Tool-Specific

| Tag | Description |
|-----|-------------|
| `#opencode` | OpenCode CLI/agents |
| `#vllm` | vLLM inference server |
| `#llama-cpp` | llama.cpp |
| `#obsidian` | Obsidian app/plugins |
| `#frigate` | Frigate NVR |
| `#caddy` | Caddy web server |

## Hygiene

Monthly review: tags with <3 uses get consolidated or removed.

```dataview
TABLE length(rows) AS "Count"
FROM ""
FLATTEN file.tags AS tag
GROUP BY tag
SORT length(rows) ASC
LIMIT 20
```
