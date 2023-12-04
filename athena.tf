#Creating a simple S3 bucket and using Athena to read data
#S3 bucket is created to store the Athena query results
resource "aws_s3_bucket" "example" {
  bucket = "-"
}
resource "aws_s3_bucket_acl" "example" {
    bucket = aws_s3_bucket.example.id
  acl    = "private"
}
#Athena workgroup is created to execute the Athena queries
#Athena database is created to store the data in S3 bucket
#Athena workgroup is associated with the database and the S3 bucket
#Athena workgroup is associated with the S3 bucket to allow Athena to read,write,delete,update,list,create data in the S3 bucket data from the S3 bucket
#Athena is used to read data from S3 bucket
resource "aws_athena_database" "example" {
  name   = "Saved"
  bucket = "s3://${aws_s3_bucket.example.id}"
}
resource "aws_athena_workgroup" "example" {
    name = "Terragroup"
}