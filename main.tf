provider "aws" {
  region = "ap-south-1"
  access_key = "AKIA3F2RQ6HIZY4A27NI"
  secret_key = "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"
}

resource "aws_iam_role" "role" {
  name = "sagemaker-notebook-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "sagemaker.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "sagemaker_policy_attachment" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSageMakerFullAccess"
  role       = aws_iam_role.role.name
}

resource "aws_iam_role_policy_attachment" "sagemaker_execution_policy_attachment" {
  policy_arn = "arn:aws:iam::768433254865:policy/service-role/AmazonSageMaker-ExecutionPolicy-20230429T130687"
  role       = aws_iam_role.role.name
}

resource "aws_sagemaker_code_repository" "my-repo" {
  code_repository_name = "my-notebook-instance-code-repo"

  git_config {
    repository_url = "https://github.com/AkiffKhoja/KNN-final-project.git"
  }
}

resource "aws_sagemaker_notebook_instance" "my_note" {
  name                    = "my-notebook-instance"
  instance_type           = "ml.t2.medium"
  volume_size =25 
  role_arn                = aws_iam_role.role.arn
  default_code_repository = aws_sagemaker_code_repository.my-repo.code_repository_name
}
