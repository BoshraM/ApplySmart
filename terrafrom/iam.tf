resource "aws_iam_user" "github_actions_user" {
  name = "github-actions-s3-user"
}

resource "aws_iam_policy" "github_actions_s3_policy" {
  name        = "GitHubActionsS3Policy"
  description = "Policy for GitHub Actions to interact with S3"
  policy      = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action   = [
          "s3:ListBucket",
          "s3:PutObject",
          "s3:GetObject",
          "s3:DeleteObject"
        ]
        Effect   = "Allow"
        Resource = [
          "arn:aws:s3:::cyf-applysmart",
          "arn:aws:s3:::cyf-applysmart/*"
        ]
      }
    ]
  })
}

resource "aws_iam_user_policy_attachment" "attach_s3_policy" {
  user       = aws_iam_user.github_actions_user.name
  policy_arn = aws_iam_policy.github_actions_s3_policy.arn
}
