# version 
0.1.0  ([changelog](./CHANGELOG.md))

# usage
```
module "template" {
  source = "git@github.com:devopsninja-info/terraform-aws-s3.git?ref=0.1.0

  name = "..." // required,

  bucket_policy_custom       = ""     // default,
  bucket_policy_RO_roles     = []     // default,
  bucket_policy_RW_roles     = []     // default,
  server_side_encryption     = ""     // default, valid options: "", "SSE-S3", "SSE-KMS"
  server_side_encryption_key = ""     // default, only valid if server_side_encryption == "SSE-KMS"
}
```
