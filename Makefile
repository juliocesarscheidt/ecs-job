#!make

TERRAFORM_PATH?="./terraform"

docker-login:
	-@echo "Docker login"
	aws ecr get-login-password --region $(AWS_DEFAULT_REGION) | \
		docker login --username AWS $(DOCKER_REGISTRY) --password-stdin

docker-build-image:
	-@echo "Building the image"
	docker image build --tag $(DOCKER_REGISTRY)/$(TASK_NAME):$(TASK_IMAGE_TAG) ./application

docker-container-run:
	-@echo "Running the container"
	docker container run --rm --name $(TASK_NAME) $(DOCKER_REGISTRY)/$(TASK_NAME):$(TASK_IMAGE_TAG)

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
		aws s3 mb s3://$(AWS_BACKEND_BUCKET) --region $(AWS_DEFAULT_REGION) --acl private

init: create-bucket
	$(MAKE) -C $(TERRAFORM_PATH) init

fmt:
	$(MAKE) -C $(TERRAFORM_PATH) fmt

validate:
	$(MAKE) -C $(TERRAFORM_PATH) validate

plan:
	$(MAKE) -C $(TERRAFORM_PATH) plan

apply:
	$(MAKE) -C $(TERRAFORM_PATH) apply

destroy:
	$(MAKE) -C $(TERRAFORM_PATH) destroy
