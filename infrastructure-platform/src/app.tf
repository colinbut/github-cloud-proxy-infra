locals {
    app_ami             = var.ami
    app_key_pair        = var.key_pair
    app_server_name     = var.app_server_name
    app_instance_type   = var.app_instance_type
    app_ssh_port        = 22
    app_protocol        = "tcp"
    app_any_port        = 0
    app_any_protocol    = "-1"
    db_instance_dns     = module.influxdb_server.private_dns
}

module "app_server" {
    source = "./modules/instances"

    ami                     = local.app_ami
    instance_type           = local.app_instance_type
    key_pair                = local.app_key_pair
    enable_public_facing    = false
    subnet_id               = lookup(module.app_subnets.subnets, "_private_subnet_a").id
    security_groups         = [aws_security_group.app_security_group.id]
    server_name             = local.app_server_name
    iam_instance_profile    = aws_iam_instance_profile.ec2_cloudwatch_instance_profile.name

    user_data               = templatefile("${path.cwd}/../../bootstrap/app-bootstrap.tmpl", { db_instance_dns = local.db_instance_dns })

    depends_on = [module.influxdb_server]
}

resource "aws_security_group" "app_security_group" {
    name        = local.app_server_name
    description = "The SG to assign to the app instance"
    vpc_id      = module.app_vpc.vpc_id
}

resource "aws_security_group_rule" "app_allow_ssh" {
    type                = "ingress"
    description         = "allow ssh"
    from_port           = local.app_ssh_port
    to_port             = local.app_ssh_port
    protocol            = local.app_protocol
    cidr_blocks         = ["10.0.2.0/24"]
    security_group_id   = aws_security_group.app_security_group.id
}

resource "aws_security_group_rule" "app_inbound_traffic" {
    type                = "ingress"
    description         = "allowing inbound access to the app"
    from_port           = var.app_port
    to_port             = var.app_port
    protocol            = local.app_protocol
    cidr_blocks         = ["10.0.2.0/24"]
    security_group_id   = aws_security_group.app_security_group.id
}

resource "aws_security_group_rule" "app_default_outbound" {
    type                = "egress"
    description         = "default_outbound"
    from_port           = local.app_any_port
    to_port             = local.app_any_port
    protocol            = local.app_any_protocol
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.app_security_group.id
}