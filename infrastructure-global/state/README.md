# State

Provisions the remote state bucket for the terraform code to use in infrastructure-platform directory.

Note that this uses terraform local state!

## Bootstrap

First run terraform using local state; 

```bash
terraform init
terraform plan
terraform apply
```

Then add the below code block to have this remote state backend bucket being managed by itself

```hcl
backend "s3" {
    bucket = "github-cloud-proxy-terraform-state"
    key = "infrastructure-global/state/terraform.tfstate"
    region = "eu-west-2"
}
```

```bash
terraform init
```

Say "yes" when asked about migrating to a new backend.

## Removing State Bucket

First need to empty the state bucket contents.

Then turn of the terraform lifecycle `prevent_destroy`. This is put in place as a precautionary measure just in-case accidently running destroy on this terraform code.

```bash
lifecycle {
    prevent_destroy = true
}
```

Then run:

```bash
terraform destroy
```