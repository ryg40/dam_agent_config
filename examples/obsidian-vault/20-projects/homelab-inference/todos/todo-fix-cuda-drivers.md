---
title: Fix CUDA driver mismatch
type: todo
project: homelab-inference
tags: [todo, cuda, troubleshoot]
created: 2026-04-28T15:00:00-04:00
status: active
source: manual
priority: 8
due: 2026-05-10
confidence: 8
related:
  - "[[todo-upgrade-vllm-version]]"
---

# Fix CUDA driver mismatch

## Description

CUDA driver version (12.2) doesn't match toolkit version (12.4). Need to either upgrade driver or downgrade toolkit.

## Acceptance Criteria

- [ ] Identify safe upgrade path
- [ ] Backup current config
- [ ] Update driver or toolkit
- [ ] Verify nvidia-smi output
- [ ] Test vLLM still works

## Notes

Blocking vLLM 0.5.x upgrade.
