# terraform-aws-eks

## Create terraform remote state bucket
* Authenticate with aws, make sure that environment variables: `AWS_REGION`, `AWS_ACCESS_KEY_ID` ,`AWS_SECRET_ACCESS_KEY` are set. If your account has MFA set up you will also need `AWS_SESSION_TOKEN`.

### Prerequisites
* [awscli](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
* jq (Optional, it parses the api response)

#### 1. Create Bucket(if you already have a bucket just set the `AWS_TERRAFORM_REMOTE_STATE_BUCKET` to its name, and skip this step):
```bash
export AWS_ACCOUNT="$(aws sts get-caller-identity | jq -r .Account)"
export AWS_TERRAFORM_REMOTE_STATE_BUCKET="domino-terraform-rs-${AWS_ACCOUNT}-${AWS_REGION}"

aws s3api create-bucket \
    --bucket "${AWS_TERRAFORM_REMOTE_STATE_BUCKET}" \
    --region ${AWS_REGION} \
    --create-bucket-configuration LocationConstraint="${AWS_REGION}" | jq .
```

#### Verify bucket exists

```bash
aws s3api head-bucket --bucket "${AWS_TERRAFORM_REMOTE_STATE_BUCKET}"
```
You should NOT see an error.

## 2. Initialize the terraform remote-state

```bash
### Set the deploy id. This will be used later as well.
export TF_VAR_deploy_id="mh-tf-test"  ## <-- Feel free to rename.
terraform init \
    -backend-config="bucket=${AWS_TERRAFORM_REMOTE_STATE_BUCKET}" \
    -backend-config="key=domino-eks/${TF_VAR_deploy_id}" \
    -backend-config="region=${AWS_REGION}"

```



## If you need to delete the bucket

```bash

aws s3 rb s3://"${AWS_TERRAFORM_REMOTE_STATE_BUCKET}" --force
```