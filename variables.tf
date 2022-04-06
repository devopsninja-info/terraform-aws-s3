// {{{ variables
variable "name" {
  type = string
}

variable "bucket_policy_custom" {
  type    = string
  default = ""
}

variable "bucket_policy_RO_roles" {
  type    = list(string)
  default = []
}

variable "bucket_policy_RW_roles" {
  type    = list(string)
  default = []
}

/*
 * default server side encryption, valid values: 
 *   - ""       - empty string, encryption disabled
 *   - "SSE-S3" - server side encryption with amazon S3-Managed keys
 *   - "SSE-KMS" - server side encryption with customer managed KMS keys
 */
variable "server_side_encryption" {
  type    = string
  default = ""
}

// only valid if server_side_encryption == "SSE-KMS"
variable "server_side_encryption_key" {
  type    = string
  default = ""
}
// }}}

// {{{ locals
locals {
  tags = {
    "Name"            = var.name
    "user:managed_by" = "terraform"
  }

  create_bucket_policy = length(var.bucket_policy_custom) > 0 || length(var.bucket_policy_RO_roles) > 0 || length(var.bucket_policy_RW_roles) > 0 ? 1 : 0
}
// }}}
