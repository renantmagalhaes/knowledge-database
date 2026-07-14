# Knowledge Database

A curated reference repository for infrastructure, DevOps, cloud, security, networking, and utility notes.

This repository collects practical commands, configuration examples, scripts, and architecture guidance for common operational tasks.

**Published site:** <https://renantmagalhaes.github.io/knowledge-database/> — the same content as below, with navigation and full-text search.

## Repository Structure

All published content lives under `docs/`, one folder per topic. Anything outside `docs/` (this README, `mkdocs.yml`, `test/`, tooling config) is not part of the published site.

- `docs/aws/` - AWS reference notes and automation scripts for CLI, IAM, S3, VPC, ECR, and related tasks.
- `docs/cron/` - Cron scheduling examples and patterns.
- `docs/data-engineering/` - Data pipeline and tooling references, including Apache NiFi.
- `docs/databases/` - SQL and NoSQL database guides, best practices, and troubleshooting notes.
- `docs/devops/` - DevOps tooling and platform documentation for Ansible, Docker, Jenkins, Kafka, Prometheus, RabbitMQ, and more.
- `docs/infrastructure/` - Infrastructure-specific guides for Proxmox, Magento, Zabbix/Grafana, RDP connectors, and other deployment topics.
- `docs/kubernetes/` - Kubernetes administration and tooling resources, including Helm, EKS, Argo CD, Flux CD, manifests, security, and cluster setup.
- `docs/network/` - Network configuration examples, Linux networking notes, and troubleshooting references.
- `docs/regex/` - Regular expression examples and sample files for text parsing.
- `docs/security/` - Security guidance for web servers, Windows, and related hardening topics.
- `docs/utils/` - Utilities, scripts, and small troubleshooting helpers for Linux, Windows interoperability, networking, and developer tooling.
- `test/` - Sandbox files and test area content (not published).

## How to Use

1. Browse the folder that matches your topic, or use the [published site](https://renantmagalhaes.github.io/knowledge-database/) and its search bar.
2. Open the markdown files and scripts for commands, sample configurations, and implementation notes.
3. Use this repository as a quick reference or jumpstart for operational tasks.

## Contribution

- Add new notes by creating a Markdown file under the matching `docs/<topic>/` folder (nested subfolders are fine). It's picked up automatically — there's no nav list to maintain.
- A folder's `README.md` becomes that section's landing page; every topic folder should have one.
- To rename a folder's sidebar title (e.g. acronyms like `AWS`), drop a `.pages` file in it: `title: AWS`.
- Update existing documents when you discover better practices or corrections.
- Keep entries focused, practical, and reusable for the team.
- Push to `master` and GitHub Actions builds and redeploys the site automatically within a couple of minutes.

### Previewing locally

```bash
python3 -m venv .venv && source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve   # live-reloading preview at http://127.0.0.1:8000
```

## Notes

- This repository is a knowledge base, not a packaged application.
- It is intended for quick reference and operational guidance.
- If you want to use scripts, inspect them first and adapt them to your environment.
