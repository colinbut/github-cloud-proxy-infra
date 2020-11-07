resource "aws_instance" "server" {
    ami                         = var.ami
    instance_type               = var.instance_type
    key_name                    = var.key_pair
    associate_public_ip_address = var.enable_public_facing
    security_groups             = var.security_groups
    subnet_id                   = var.subnet_id
    iam_instance_profile        = var.iam_instance_profile

    user_data                   = var.user_data

    tags = {
        Name = var.server_name
    }
}