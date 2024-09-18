resource "aws_s3_bucket" "s3-tfstate" {
  bucket = local.s3_name
  tags = {
    Name      = "s3-bucket-for-tfstate"
    yor_trace = "b9064c37-d999-47f4-bb0b-601ac09edfc6"
  }
}

resource "aws_s3_bucket_public_access_block" "s3-tfstate" {
  bucket              = aws_s3_bucket.s3-tfstate.id
  block_public_acls   = false
  block_public_policy = false
}
