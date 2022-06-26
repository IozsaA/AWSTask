variable "bucket_prefix" {
  type        = string
  description = "Name of the s3 bucket to be created."
}

variable "region" {
  type        = string
  default     = "us-east-1"
  description = "Name of the s3 bucket to be created."
}

variable "acces_key" {
  type        = string
  description = "Id of the accesss key"
}

variable "secret_key" {
  type        = string
  description = "Id of the secret key"
}