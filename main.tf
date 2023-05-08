provider "aws" {
  region = "ap-south-1"
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

resource "aws_sagemaker_code_repository" "my-repo" {
  code_repository_name = "my-notebook-instance-code-repo"

  git_config {
    repository_url = "https://github.com/AkiffKhoja/KNN-final-project.git"
  }
}

resource "aws_sagemaker_notebook_instance" "my_note" {
  name                    = "my-notebook-instance"
  instance_type           = "ml.t2.medium"
  volume_size             = 25 
  role_arn                = aws_iam_role.role.arn
  default_code_repository = aws_sagemaker_code_repository.my-repo.code_repository_name

  tags = {
    Name = "Project"
  }
}
