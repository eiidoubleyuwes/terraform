
#Create S3 bucket
resource "aws-s3-bucket" "newbucket" {
    bucket = "new_bucket"
    acl = "public"
    versioning {
        enabled = true
    }
    tags = {
        Name = "newbucket"
    }
}