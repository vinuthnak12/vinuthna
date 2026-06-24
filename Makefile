.PHONY: build run validate terraform-validate k8s-validate

build:
	docker build -t vinuthna-portfolio:local .

run:
	docker compose up --build

validate: terraform-validate k8s-validate

terraform-validate:
	terraform -chdir=terraform fmt -check -recursive
	terraform -chdir=terraform init -backend=false
	terraform -chdir=terraform validate

k8s-validate:
	kubectl kustomize kubernetes/overlays/dev > /dev/null
	kubectl kustomize kubernetes/overlays/prod > /dev/null
