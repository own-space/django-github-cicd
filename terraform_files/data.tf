# data "aws_iam_policy_document" "instance-assume-role-policy" {
#   statement {
#     actions = ["sts:AssumeRole"]

#     principals {
#       type        = "Service"
#       identifiers = ["ec2.amazonaws.com"]
#     }
#   }
# }

data "aws_iam_policy_document" "d-policy" {
  statement {
    actions = ["sts:AssumeRole", "autoscaling:*", "codedeploy:*", "ec2:*", "lambda:*", "ecs:*", "elasticloadbalancing:*", "iam:AddRoleToInstanceProfile", "iam:AttachRolePolicy", "iam:CreateInstanceProfile", "iam:CreateRole", "iam:DeleteInstanceProfile", "iam:DeleteRole", "iam:DeleteRolePolicy", "iam:GetInstanceProfile", "iam:GetRole", "iam:GetRolePolicy", "iam:ListInstanceProfilesForRole", "iam:ListRolePolicies", "iam:ListRoles", "iam:PutRolePolicy", "iam:RemoveRoleFromInstanceProfile", "s3:*", "ssm:*"]
    principals {
      type        = "Resource"
      identifiers = ["*"]
    }
  }
}

data "aws_iam_policy_document" "deployment-service-policy" {
  statement {
    sid = "CodeDeployAccessPolicy"

    effect = "Allow"

    actions = ["sts:AssumeRole", "autoscaling:*", "codedeploy:*", "ec2:*", "lambda:*", "ecs:*", "elasticloadbalancing:*", "iam:AddRoleToInstanceProfile", "iam:AttachRolePolicy", "iam:CreateInstanceProfile", "iam:CreateRole", "iam:DeleteInstanceProfile", "iam:DeleteRole", "iam:DeleteRolePolicy", "iam:GetInstanceProfile", "iam:GetRole", "iam:GetRolePolicy", "iam:ListInstanceProfilesForRole", "iam:ListRolePolicies", "iam:ListRoles", "iam:PutRolePolicy", "iam:RemoveRoleFromInstanceProfile", "s3:*", "ssm:*"]

  }
}