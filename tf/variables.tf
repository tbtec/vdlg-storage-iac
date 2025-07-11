variable "region" {
  description = "The default region to use for AWS"
  default     = "us-east-1"
}


variable "bucket_name" {
  description = "The Bucket name for the S3 bucket used for video processing"
  type        = string
  default     = "vdlg-video-files"
}

variable "tags" {
  description = "The default tags to use for AWS resources"
  type        = map(string)
  default = {
    App = "storage"
  }
}
