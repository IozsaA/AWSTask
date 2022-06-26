variable "bucket_prefix" {
  type        = string
  description = "Name of the s3 bucket to be created."
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Name of the s3 bucket to be created."
}

variable "ACCESS_KEY" {
  type        = string
  description = "Id of the accesss key"
}

variable "SECRET_KEY" {
  type        = string
  description = "Id of the secret key"
}