include ./env_vars.tf
PROJECT_NUMBER ?= $$(gcloud projects list --filter=${TF_VAR_project_id} --format="value(PROJECT_NUMBER)")
TF_STATE_BUCKET ?= gs://tf-state-${PROJECT_NUMBER}

# Makefile command prefixes
continue_on_error = -
suppress_output = @

.PHONY: $(shell sed -n -e '/^$$/ { n ; /^[^ .\#][^ ]*:/ { s/:.*$$// ; p ; } ; }' $(MAKEFILE_LIST))

.DEFAULT_GOAL := help

help: ## This is help
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)

bootstrap: ## This creates the Terraform Backend Bucket if one does not exist
	$(suppress_output)echo "Verifying TF State Backend  ${TF_STATE_BUCKET} .. Creating one If Unavailable"
	@if ! gcloud storage buckets describe ${TF_STATE_BUCKET} > /dev/null 2>&1; then \
		gcloud storage buckets create ${TF_STATE_BUCKET} --location=${TF_VAR_region} --default-storage-class=STANDARD; \
	else \
		gcloud storage buckets update ${TF_STATE_BUCKET} --versioning > /dev/null 2>&1 || (echo "Error enabling versioning on $(BUCKET_NAME)"; exit 1); \
	fi

sa_init: bootstrap ## Runs the Terraform INIT Setting Up the Databricks Service Account
	$(suppress_output)echo "Setting the Terraform Vars..."
	. env_vars.tf
	cd infra/sa && terraform init
	cd infra/databricks && terraform init
	
plan_sa: sa_init
	cd infra/sa && terraform plan

create_sa: sa_init ## Runs the Terraform for Setting Up the Databricks Service Account
	cd infra/sa && terraform apply --auto-approve

drop_sa: sa_init ## Runs the Terraform for Dropping the Databricks Service Account
	cd infra/sa && terraform destroy --auto-approve

create_ws: sa_init ## Runs the Terraform for Setting Up the Databricks Service Account
	cd infra/databricks && terraform apply --auto-approve