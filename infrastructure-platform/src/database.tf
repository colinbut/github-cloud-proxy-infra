locals {
    db_ami                  = var.ami
    db_key_pair             = var.key_pair
    db_server_name          = var.db_server_name
    db_instance_type        = var.db_instance_type
    db_ssh_port             = 22
    db_protocol             = "tcp"
    db_any_port             = 0
    db_any_protocol         = "-1"
    db_backup_bucket_name   = aws_s3_bucket.influxdb-backup-bucket.bucket
}

resource "aws_s3_bucket" "influxdb-backup-bucket" {
    bucket = var.db_backup_bucket_name

    versioning {
        enabled = true
    }

    server_side_encryption_configuration {
        rule {
            apply_server_side_encryption_by_default {
                sse_algorithm = "AES256"
            }
        }
    }
}

module "influxdb_server" {
    source = "./modules/instances"

    ami                     = local.db_ami
    instance_type           = local.db_instance_type
    key_pair                = local.db_key_pair
    enable_public_facing    = false
    subnet_id               = lookup(module.app_subnets.subnets, "_private_subnet_a").id
    security_groups         = [aws_security_group.db_security_group.id]
    iam_instance_profile    = aws_iam_instance_profile.ec2_s3_instance_profile.name
    server_name             = local.db_server_name

    user_data               = templatefile("${path.cwd}/../../bootstrap/db-bootstrap.tmpl", { db_backup_bucket_name = local.db_backup_bucket_name })

    depends_on = [aws_s3_bucket.influxdb-backup-bucket]
}

resource "aws_security_group" "db_security_group" {
    name        = local.db_server_name
    description = "The SG to assign to the database instance"
    vpc_id      = module.app_vpc.vpc_id
}

resource "aws_security_group_rule" "db_allow_ssh" {
    type                = "ingress"
    description         = "allow ssh"
    from_port           = local.db_ssh_port
    to_port             = local.db_ssh_port
    protocol            = local.db_protocol
    cidr_blocks         = ["10.0.2.0/24"]
    security_group_id   = aws_security_group.db_security_group.id
}

resource "aws_security_group_rule" "db_inbound_traffic" {
    type                = "ingress"
    description         = "allowing inbound access to the db"
    from_port           = var.db_port
    to_port             = var.db_port
    protocol            = local.db_protocol
    cidr_blocks         = ["10.0.1.0/24"]
    security_group_id   = aws_security_group.db_security_group.id
}

resource "aws_security_group_rule" "db_default_outbound" {
    type                = "egress"
    description         = "default_outbound"
    from_port           = local.db_any_port
    to_port             = local.db_any_port
    protocol            = local.db_any_protocol
    cidr_blocks         = ["0.0.0.0/0"]
    security_group_id   = aws_security_group.db_security_group.id
}

resource "aws_ebs_volume" "data_volume" {
    availability_zone   = "eu-west-1a"
    size                = 100
    type                = "gp2"

    tags = {
        Name = "InfluxDB-Data-Volume"
    }
}

resource "aws_ebs_volume" "wal_volume" {
    availability_zone   = "eu-west-1a"
    size                = 40
    type                = "io1"
    iops                = 100

    tags = {
        Name = "InfluxDB-Wal-Volume"
    }
}

resource "aws_volume_attachment" "data_ebs_att" {
    device_name     = "/dev/xvdf"
    volume_id       = aws_ebs_volume.data_volume.id
    instance_id     = module.influxdb_server.instance_id
    force_detach    = true
}

resource "aws_volume_attachment" "wal_ebs_att" {
    device_name     = "/dev/xvds"
    volume_id       = aws_ebs_volume.wal_volume.id
    instance_id     = module.influxdb_server.instance_id
    force_detach    = true
}