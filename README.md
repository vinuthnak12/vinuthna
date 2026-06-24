# Vinuthna Koganti - DevOps Portfolio

Blog: [vinuthna.hashnode.dev](https://vinuthna.hashnode.dev/)

A static professional portfolio evolved into an end-to-end DevOps reference project: Docker, GitHub Actions, Terraform, AWS EKS, Kubernetes, Argo CD, Prometheus, and Grafana.

The website is available in English and French. It automatically follows the visitor's browser language on first visit and remembers manual EN/FR selection.

## Local run

```bash
docker compose up --build
curl http://localhost:8080/healthz
```

## Architecture

Developer push -> GitHub Actions validation and image scan -> GHCR immutable image -> Git image-tag update -> Argo CD reconciliation -> EKS workload -> Prometheus scrape -> Grafana dashboards and Alertmanager.

## Repository map

- `Dockerfile`, `nginx.conf`: hardened runtime
- `.github/workflows/`: validation and release automation
- `terraform/`: AWS VPC and EKS provisioning
- `kubernetes/`: reusable base plus dev/prod overlays
- `argocd/`: GitOps application
- `monitoring/`: Prometheus/Grafana configuration and alert example
- `docs/ROADMAP.md`: phased implementation, operations, and definition of done

## Before cloud deployment

Replace all `OWNER` and `example.com` placeholders, create a remote Terraform backend, pin an image version, configure DNS/TLS, and use GitHub OIDC for AWS access. EKS incurs ongoing AWS cost; destroy lab infrastructure when it is not being demonstrated.

See [the full roadmap](docs/ROADMAP.md).
