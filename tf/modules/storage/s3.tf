data "aws_sns_topic" "input_topic" {
  name = "InputTopic"
}

data "aws_sns_topic" "output_topic" {
  name = "OutputTopic"
}

resource "aws_s3_bucket" "vdlg_video_bucket" {
  bucket = var.bucket_name
  force_destroy = true
}

resource "aws_sns_topic_policy" "input_topic_allow_s3_publish" {
  arn = data.aws_sns_topic.input_topic.arn

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "s3.amazonaws.com"
        },
        Action = "SNS:Publish",
        Resource = data.aws_sns_topic.input_topic.arn,
        Condition = {
          ArnLike = {
            "aws:SourceArn" = aws_s3_bucket.vdlg_video_bucket.arn
          }
        }
      }
    ]
  })
}

resource "aws_s3_bucket_notification" "vdlg_video_bucket_notification" {
  bucket = aws_s3_bucket.vdlg_video_bucket.id

  topic {
    topic_arn     = data.aws_sns_topic.input_topic.arn
    events        = ["s3:ObjectCreated:*"]
    filter_prefix = "input"

  }

  depends_on = [ 
    aws_s3_bucket.vdlg_video_bucket, 
    aws_sns_topic_policy.input_topic_allow_s3_publish
  ]
}