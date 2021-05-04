#!make

PLAN_FILE?=tfplan
ECS_CLUSTER_NAME?=ecs-job-cluster

docker-login:
	-@echo "Docker login"
	aws ecr get-login-password --region $(AWS_DEFAULT_REGION) | \
		docker login --username AWS $(DOCKER_REGISTRY) --password-stdin

docker-build-image:
	-@echo "Building the image"
	docker image build --tag $(DOCKER_REGISTRY)/$(TASK_NAME):$(TASK_IMAGE_TAG) ./application

docker-create-repository:
	-@echo "Create repository"
	aws ecr describe-repositories --repository-names $(TASK_NAME) --region $(AWS_DEFAULT_REGION) || \
		aws ecr create-repository --repository-name $(TASK_NAME) --region $(AWS_DEFAULT_REGION)

push-image: docker-login docker-build-image docker-create-repository
	-@echo "Pushing the image"
	docker image push $(DOCKER_REGISTRY)/$(TASK_NAME):$(TASK_IMAGE_TAG)

create-bucket:
	-@echo "Creating the bucket"
	aws s3 ls s3://$(AWS_BACKEND_BUCKET) --region $(AWS_DEFAULT_REGION) || \
		aws s3 mb s3://$(AWS_BACKEND_BUCKET) --region $(AWS_DEFAULT_REGION)

init: create-bucket
	-@echo "Init"
	terraform init -upgrade=true \
		-backend-config="bucket=$(AWS_BACKEND_BUCKET)" \
		-backend-config="key=state.tfstate" \
		-backend-config="region=$(AWS_DEFAULT_REGION)" \
		-backend-config="workspace_key_prefix=terraform/$(ECS_CLUSTER_NAME)" \
		-backend-config="access_key=$(AWS_ACCESS_KEY_ID)" \
		-backend-config="secret_key=$(AWS_SECRET_ACCESS_KEY)" \
		-backend-config="encrypt=true"

	-@terraform workspace new development 2> /dev/null
	-@terraform workspace new production 2> /dev/null
	terraform workspace select $(ENV)

	make plan

fmt:
	terraform fmt -write=true -recursive

validate:
	terraform validate

plan: validate
	-@echo "Plan"
	terraform plan \
		-out=$(PLAN_FILE) \
		-var-file=$(ENV).tfvars \
		-var aws_region="$(AWS_DEFAULT_REGION)" \
		-var ecs_cluster_name="$(ECS_CLUSTER_NAME)" \
		-var docker_registry="$(DOCKER_REGISTRY)" \
		-var task_name="$(TASK_NAME)" \
		-var task_image_tag="$(TASK_IMAGE_TAG)" \
		-var task_schedule_expression="$(TASK_SCHEDULE_EXPRESSION)" \
		-input=false

apply: plan
	-@echo "Apply"
	terraform apply $(PLAN_FILE)
	terraform output -json

destroy:
	-@echo "Destroy"
	terraform destroy \
		-var-file=$(ENV).tfvars \
		-auto-approve
