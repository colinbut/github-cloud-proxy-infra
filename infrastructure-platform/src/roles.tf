data "aws_iam_policy" "CloudWatchAgentServerPolicy" {
    arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
}

resource "aws_iam_role" "ec2_cloudwatch_role" {
    name = "ec2_cloudwatch_role"
    assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "ec2.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "ec2_cloudwatch_role_attach" {
    role        = aws_iam_role.ec2_cloudwatch_role.name
    policy_arn  = data.aws_iam_policy.CloudWatchAgentServerPolicy.arn
}

resource "aws_iam_instance_profile" "ec2_cloudwatch_instance_profile" {
    role = aws_iam_role.ec2_cloudwatch_role.name
    name = "github-cloud-proxy-ec2-cloudwatch-instance-profile"
}

# lambda
resource "aws_iam_policy" "lambda_ec2" {
    name        = "lambda_ec2"
    path        = "/"
    description = "IAM policy for lambda to call ec2"

    policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ec2:RebootInstances",
                    "ec2:Start*",
                    "ec2:Stop*"
                ],
                "Resource": "*"
            },
            {
                "Effect": "Allow",
                "Action": [
                    "logs:CreateLogStream",
                    "logs:PutLogEvents",
                    "logs:CreateLogGroup"
                ],
                "Resource": "arn:aws:logs:*:*:*"
            }
        ]
    }
    EOF
}

resource "aws_iam_role" "lambda_ec2_role" {
    name = "lambda_ec2_role"
    assume_role_policy = <<EOF
{
        "Version": "2012-10-17",
        "Statement": [
            {
                "Action": "sts:AssumeRole",
                "Principal": {
                    "Service": "lambda.amazonaws.com"
                },
                "Effect": "Allow",
                "Sid": ""
            }
        ]
    }
    EOF
}

resource "aws_iam_role_policy_attachment" "lambda_role_policy" {
    role        = aws_iam_role.lambda_ec2_role.name
    policy_arn  = aws_iam_policy.lambda_ec2.arn
}

data "aws_iam_policy_document" "instance_assume_role_policy" {
    statement {
        actions = ["sts:AssumeRole"]
        principals {
            type        = "Service"
            identifiers = ["ec2.amazonaws.com"]
        }
    }
}
resource "aws_iam_policy" "s3_policy" {
    name        = "s3_put_object_policy"
    path        = "/"
    description = "Policy to put objects into S3 buckets"

    policy      = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "s3:PutObject",
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}

resource "aws_iam_role" "ec2_s3_role" {
    name                = "github-cloud-proxy-ec2-s3-role"
    description         = "The role to allow EC2 instances to put objects into S3 buckets"
    assume_role_policy  = data.aws_iam_policy_document.instance_assume_role_policy.json
}

resource "aws_iam_role_policy_attachment" "ec2_s3_role_policy_attachment" {
    role        = aws_iam_role.ec2_s3_role.name
    policy_arn  = aws_iam_policy.s3_policy.arn
}

resource "aws_iam_instance_profile" "ec2_s3_instance_profile" {
    name = "github-cloud-proxy-ec2-s3-instance-profile"
    role = aws_iam_role.ec2_s3_role.name
}