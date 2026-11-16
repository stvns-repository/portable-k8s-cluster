# Phase 1 - Foundation

> **Security Disclaimer:** This guide uses **static AWS IAM access keys** configured via the AWS CLI to streamline the local deployment procedure. You can opt out of this approach by either using  IAM Roles, assuming roles via STS, or by employing OIDC federation following the principle of least privilege.

This very first phase will create the underlying networking infrastructure (VPC, Subnets, Routing, NACLs, & Security groups), as well as the EKS cluster, and the initial IAM policies.

Make sure that your terminal is on the correct location: `/portable-k8s-cluster/terraform/aws/phase-1-foundation/`

- **Pre-requisites**
  - **1.**: Login to your AWS Account and create an S3 bucket (with default security - not set to public) on `us-west-2` (Oregon) region. You are free to use a different region but make sure to update the `backend.aws.tf` file.
  - **2.**: Create a new file named `backend.hcl` with the following details:
    ```hcl
    bucket = "<S3 bucket created from name step>"
    region = "us-west-2"
    ```
  - **3.**: From the AWS Console, create an IAM user with access keys ([AWS Documentation](https://docs.aws.amazon.com/IAM/latest/UserGuide/access-keys_inline-policy.html)), then attach the policy below as an inline policy:
    ```json
    {
      "Version": "2012-10-17",
      "Statement": [
        {
          "Sid": "FullInfrastructureManagement",
          "Effect": "Allow",
          "Action": [
            "ec2:*",
            "eks:*",
            "iam:*",
            "ecr:*",
            "logs:*"
          ],
          "Resource": "*"
        },
        {
          "Sid": "TerraformS3StateAccess",
          "Effect": "Allow",
          "Action": [
            "s3:GetObject",
            "s3:PutObject",
            "s3:DeleteObject",
            "s3:ListBucket"
          ],
          "Resource": [
            "arn:aws:s3:::<REPLACE_WITH_S3_bucket_name_created_from_step_1>",
            "arn:aws:s3:::<REPLACE_WITH_S3_bucket_name_created_from_step_1>/*"
          ]
        }
      ]
    }
    ```
  - **4.**: From your VS Code (or terminal), use the `aws configure` CLI tool ([AWS Documentation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-quickstart.html)) and enter the Access Key and Secret Access Key:
    ```text
    AWS Access Key ID [None]: <Access ID Key>
    AWS Secret Access Key [None]: <Secret Access Key>
    Default region name [None]: us-west-2
    ```
  - **5.**: After which, initialize terraform:
    ```bash
    terraform init -backend-config=backend.hcl
    terraform plan
    terraform apply
    ```