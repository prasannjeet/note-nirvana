cd terraform
terraform init
terraform plan -out="my_plan.tfplan"
terraform apply "my_plan.tfplan" -auto-approve
