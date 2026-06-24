# Production DevOps roadmap

This repository starts as a static HTML portfolio. The target architecture packages it as an unprivileged container, publishes immutable images through GitHub Actions, provisions AWS EKS with Terraform, reconciles Kubernetes state with Argo CD, and exposes operational signals through Prometheus and Grafana.

## 1. Baseline and ownership

- Replace inherited portfolio content with Vinuthna Koganti's DevOps profile: 5 years of experience, Intellect Design Arena and Inube Software Solutions, AWS/EKS, GitOps, CI/CD, Terraform, Docker, Kubernetes, Prometheus, and Grafana.
- Protect `main`, require CI, enable Dependabot and secret scanning in GitHub.
- Record decisions in `docs/adr/` as the architecture evolves.

**Evidence:** `index.html`, `README.md`, and this roadmap.

## 2. Containerize the static site

- `Dockerfile` uses an unprivileged, pinned Nginx base and includes a health check.
- `nginx.conf` adds health routing, cache headers, and basic browser security headers.
- `docker-compose.yml` provides a one-command local environment with a read-only filesystem.

Run `docker compose up --build`, then open `http://localhost:8080`.

## 3. Build a secure CI pipeline

- `.github/workflows/ci.yml` validates Terraform and Kustomize, builds the image, smoke-tests `/healthz`, and fails on high/critical Trivy findings.
- `.github/workflows/release.yml` publishes multi-architecture GHCR images with provenance and an SBOM only from semantic-version tags.
- Configure GitHub environments and use OIDC for AWS; never store long-lived AWS keys.

## 4. Provision AWS infrastructure with Terraform

- `terraform/` creates a three-AZ VPC and an EKS cluster with managed nodes and IRSA.
- Copy `backend.tf.example` to `backend.tf` only after creating the S3 state bucket and lock table.
- Use separate state and tfvars per environment. Run `terraform plan` in PRs and require approval before `apply` in the protected production environment.

Commands: `terraform -chdir=terraform init`, `plan -out=tfplan`, then approved `apply tfplan`.

## 5. Deploy through Kubernetes

- `kubernetes/base/` defines an unprivileged Deployment, probes, resource budgets, Service, Ingress, PDB, NetworkPolicy, and ServiceMonitor.
- `kubernetes/overlays/` separates dev and production replica counts, hosts, and image versions.
- Replace `OWNER`, domains, and the image tag before deployment. Install an ingress controller and cert-manager for TLS.

## 6. Introduce GitOps with Argo CD

- Install Argo CD in its own namespace, apply `argocd/application.yaml`, and let it reconcile the production overlay.
- Release automation should update the production image tag in Git, ideally through a pull request. Argo CD then syncs, self-heals drift, and prunes removed resources.
- Add an Argo CD Project with repository/destination allowlists before sharing the cluster.

## 7. Add Prometheus and Grafana

- Install `kube-prometheus-stack` with `monitoring/kube-prometheus-stack-values.yaml`.
- A Prometheus Operator Probe uses the Blackbox Exporter to verify application availability. For richer Nginx request metrics, add `nginx-prometheus-exporter` as a sidecar and expose `stub_status` internally.
- Import dashboards for Kubernetes capacity, pod health, ingress latency, HTTP error rate, and deployment changes. Route Alertmanager notifications to the team's chosen channel.

## 8. Production hardening

- Add External Secrets with AWS Secrets Manager, cert-manager, AWS Load Balancer Controller, autoscaling, backups, and Pod Security Admission.
- Add Checkov/tfsec, kubeconform, image signing with Cosign, admission verification, and scheduled disaster-recovery exercises.
- Define SLOs: 99.9% availability, p95 latency below 300 ms, and zero critical image vulnerabilities. Track error-budget burn in Grafana.

## 9. Portfolio demonstration

- Include architecture and deployment-flow diagrams, screenshots of Argo CD sync and Grafana dashboards, a short failure/recovery demo, cost estimates, and a teardown command.
- Explain trade-offs honestly: EKS demonstrates production orchestration but is expensive for a static page; S3/CloudFront is the pragmatic hosting choice. This cluster is a skills showcase with explicit cost controls.

## Definition of done

CI is required and green; releases are immutable and scanned; infrastructure is reproducible; Git is the deployment source of truth; drift self-heals; dashboards and alerts are actionable; secrets are externalized; rollback and teardown are documented and tested.
