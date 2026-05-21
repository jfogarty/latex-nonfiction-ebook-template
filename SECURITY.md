# Security Policy

## Supported versions

| Version | Supported |
|---------|-----------|
| 2026 modernization branch | yes |
| Legacy master (pre-2026) | best effort |

## Reporting a vulnerability

Please open a private security advisory on GitHub or email the maintainers listed in [MAINTAINERS](MAINTAINERS).

Do not open public issues for undisclosed security problems.

## Scope

This template processes local LaTeX source. Risks are primarily:

* Untrusted LaTeX input (`\write18`, shell-escape) — disabled by default except `just web` which requires `-shell-escape` for lwarp.
* Third-party Docker base image supply chain — pin tags in production forks.
