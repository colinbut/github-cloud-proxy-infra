variable "db_backup_bucket_name" {
    type        = string
    description = "The name of the bucket that would store the InfluxDB backups"
}

variable "alarms_email" {
    type        = string
    description = "The email to send notification to"
}

variable "threshold" {
    type        = number
    description = "The breaching threshold"
}

variable "period" {
    type        = string
    description = "The period to capture data for"
}

variable "app_server_name" {
    type        = string
    description = "The name of the app server"
}

variable "app_instance_type" {
    type        = string
    description = "The type of ec2 instance to provision"
}

variable "db_server_name" {
    type        = string
    description = "The name of the db server"
}

variable "db_instance_type" {
    type        = string
    description = "The type of ec2 instance to provision"
}

variable "ami" {
    type        = string
    description = "The ami to use"
    default     = "ami-0ea3405d2d2522162" # Amazon Linux 2 on eu-west-1
}

variable "db_port" {
    type        = number
    description = "The access port on which the db instance is hosted"
}

variable "app_port" {
    type        = number
    description = "The access port on which the app instance is hosted"
}

variable "key_pair" {
    type        = string
    description = "The name of the keypair"
}