resource "aws_s3_bucket" "static" {
  bucket = "cyf-frontend-applysmart"
  tags = {
    Name = "applysmart-deploy"
  }
}
resource "aws_s3_bucket_public_access_block" "static" {
  bucket                  = aws_s3_bucket.static.id
  ignore_public_acls      = false
  block_public_acls       = false
  restrict_public_buckets = false
  block_public_policy     = false
}
resource "aws_s3_bucket_policy" "s3_bucket_policy" {
  bucket = aws_s3_bucket.static.id
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Id" : "Policy1706102283611",
    "Statement" : [
      {
        "Sid" : "Stmt1706100891822",
        "Effect" : "Allow",
        "Principal" : "*",
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.static.arn}/*"
      }
    ]
  })
}
resource "aws_s3_bucket_website_configuration" "static" {
  bucket = aws_s3_bucket.static.id
  index_document {
    suffix = "index.html"
  }
  error_document {
    key = "error.html"
  }
  routing_rule {
    condition {
      key_prefix_equals = "docs/"
    }
    redirect {
      replace_key_prefix_with = "documents/"
    }
  }
}
module "template_files" {
  source = "hashicorp/dir/template"
  base_dir = "${path.module}/../client/build"
}
resource "aws_s3_object" "static_files" {
  for_each = module.template_files.files
  bucket       = aws_s3_bucket.static.id
  key          = each.key
  content_type = each.value.content_type
  source  = each.value.source_path
  content = each.value.content
  etag = each.value.digests.md5
}









