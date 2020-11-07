locals {
    region = "eu-west-1"
}

resource "aws_sns_topic" "java_proxy_alarms" {
    name         = "Java-Proxy-Metrics-Alarm"
    display_name = "java proxy metrics alarm"

    provisioner "local-exec" {
        command = "aws sns subscribe --region ${local.region} --topic-arn ${self.arn} --protocol email --notification-endpoint ${var.alarms_email}"
    }
}