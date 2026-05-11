---
title: Upgrade vLLM to 0.5.x
type: todo
project: homelab-inference
tags: [todo, vllm, upgrade]
created: 2026-04-29T10:00:00-04:00
status: blocked
source: manual
priority: 6
due: 2026-05-15
blocked_by: "[[todo-fix-cuda-drivers]]"
confidence: 7
related:
  - "[[snippet-vllm-launch-command]]"
---

# Upgrade vLLM to 0.5.x

## Description

Upgrade vLLM from 0.4.x to 0.5.x for improved performance and new features. Blocked until CUDA driver issue is resolved.

## Acceptance Criteria

- [ ] CUDA drivers updated (blocked)
- [ ] vLLM upgraded to 0.5.x
- [ ] Test with existing models
- [ ] Update launch scripts if needed
- [ ] Benchmark performance delta

## Notes

0.5.x has chunked prefill and speculative decoding improvements.
