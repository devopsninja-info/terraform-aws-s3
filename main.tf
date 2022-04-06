// {{{ s3
resource "aws_s3_bucket" "main" {
  bucket = var.name

  tags = local.tags
}

resource "aws_s3_bucket_acl" "main" {
  bucket = var.name

  acl = "private"
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse-kms" {
  count = var.server_side_encryption == "SSE-KMS" ? 1 : 0

  bucket = var.name

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.server_side_encryption_key
      sse_algorithm     = "aws:kms"
    }
  }
}

resource "aws_s3_bucket_server_side_encryption_configuration" "sse-s3" {
  count = var.server_side_encryption == "SSE-S3" ? 1 : 0

  bucket = var.name

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}
// }}}

// {{{ s3 bucket policy
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = var.name

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "main" {
  count = local.create_bucket_policy

  bucket = var.name

  policy = length(var.bucket_policy_custom) > 0 ? var.bucket_policy_custom : data.aws_iam_policy_document.main.json
}

data "aws_iam_policy_document" "main" {

  /*
   *
   * dynamic trick (nice1bruva https://www.youtube.com/watch?v=qksndNDMDOw):
   *   "dynamic" is purely used here as "if",
   *   it allows to conditionally create a statement block
   *
   */

  /*
   * RO access to the bucket
   */
  dynamic "statement" {
    for_each = length(var.bucket_policy_RO_roles) > 0 ? [true] : []
    iterator = _
    content {
      effect = "Allow"

      principals {
        type = "AWS"
        identifiers = var.bucket_policy_RO_roles
      }

      actions = [
        "s3:ListBucket",
        "s3:GetObject",
      ]

      resources = [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*",
      ]
    }
  }

  /*
   * RW access to the bucket
   */
  dynamic "statement" {
    for_each = length(var.bucket_policy_RW_roles) > 0 ? [true] : []
    iterator = _
    content {
      effect = "Allow"

      principals {
        type = "AWS"
        identifiers = var.bucket_policy_RW_roles
      }

      actions = [
        "s3:GetObject",
        "s3:ListBucket",
        "s3:PutObject",
      ]

      resources = [
        "arn:aws:s3:::${var.name}",
        "arn:aws:s3:::${var.name}/*",
      ]
    }
  }
}
// }}}
