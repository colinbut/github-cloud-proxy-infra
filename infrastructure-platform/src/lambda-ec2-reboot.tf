resource "aws_lambda_function" "lambda_ec2_reboot" {
    filename        = "lambda_function_payload.zip"
    function_name   = "lambda_ec2_reboot_instances"
    role            = aws_iam_role.lambda_ec2_role.arn
    handler         = "lambda_function.lambda_handler"
    runtime         = "python3.7"
    timeout         = 10

    environment {
        variables = {
            region = "eu-west-1",
            instance_id = module.app_server.instance_id
        }
    }
}