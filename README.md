# ECS Job

This project will launch an ECS task that is scheduled by CloudWatch, in a Cron-Like fashion, creating a Job which will be triggered on the defined time.

```bash
export ENV="development"
export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
export AWS_DEFAULT_REGION="$AWS_DEFAULT_REGION"
export AWS_BACKEND_BUCKET="backend-bucket-$(cat /dev/urandom | tr -dc 'a-z0-9' | fold -w 12 | head -n1)"
export ECS_CLUSTER_NAME="ecs-job-cluster"
export DOCKER_REGISTRY="$AWS_ACCOUNT.dkr.ecr.$AWS_DEFAULT_REGION.amazonaws.com"
export TASK_NAME="simple-job"
export TASK_IMAGE_TAG="0.0.1"
export TASK_SCHEDULE_EXPRESSION="cron(0/5 * * * ? *)"

# login into the ECR, build the image, creates the repository (if doesn't exist) and pushes the image to the repository
make push-image

# create the backend bucket on S3 (if doesn't exist), initializes the terraform, create the workspaces, validate and do the plan
make init

# apply the previous plan
make apply
```
