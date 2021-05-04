# Commands

<https://docs.aws.amazon.com/AmazonECS/latest/userguide/using_awslogs.html>
<https://github.com/vthub/scheduled-ecs-task/tree/master/infrastructure>

```bash
docker image build \
  --tag juliocesarmidia/simple-job:latest \
  --tag juliocesarmidia/simple-job:v1.0.0 \
  -f Dockerfile ./application

docker container run --rm --name simple-job juliocesarmidia/simple-job:v1.0.0

docker image push juliocesarmidia/simple-job:latest
docker image push juliocesarmidia/simple-job:v1.0.0

docker image ls --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}" --filter="reference=juliocesarmidia/simple-job:latest"
docker image ls --format "table {{.ID}}\t{{.Repository}}\t{{.Tag}}\t{{.Size}}" --filter="reference=juliocesarmidia/simple-job:v1.0.0"

docker container stop simple-job
docker container rm -f simple-job
```

## EC2 IP info

```bash
PUBLIC_IP=$(curl http://169.254.169.254/latest/meta-data/public-ipv4)
PRIVATE_IP=$(curl http://169.254.169.254/latest/meta-data/local-ipv4)
```

## Terraform commands

```bash
terraform fmt -write=true -recursive

terraform init -backend=true

WORKSPACE="development"
terraform workspace new "${WORKSPACE}" 2> /dev/null \
  || terraform workspace select "${WORKSPACE}"

terraform workspace list
terraform workspace show

terraform validate

terraform plan -var-file="$WORKSPACE.tfvars" \
  -detailed-exitcode -input=false

terraform plan -var-file="$WORKSPACE.tfvars" \
  -detailed-exitcode -input=false -target=resource

terraform refresh -var-file="$WORKSPACE.tfvars"

terraform show

terraform output -var-file="$WORKSPACE.tfvars"

terraform apply -var-file="$WORKSPACE.tfvars" \
  -auto-approve

terraform apply -var-file="$WORKSPACE.tfvars" \
  -auto-approve -target=resource

terraform destroy -var-file="$WORKSPACE.tfvars" \
  -auto-approve
```
