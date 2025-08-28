
SHELL := /bin/bash

init:
	terraform init

fmt:
	terraform fmt -recursive

validate:
	terraform validate

plan: fmt validate
	terraform plan

apply:
	terraform apply -auto-approve

destroy:
	terraform destroy -auto-approve
