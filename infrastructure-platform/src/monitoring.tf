resource "aws_cloudwatch_metric_alarm" "xxx_java_proxy_memory_usage" {
    alarm_name          = "java_proxy_memory_threshold_alarm"
    comparison_operator = "GreaterThanOrEqualToThreshold"
    evaluation_periods  = "1"
    metric_name         = "mem_used_percent"
    namespace           = "CWAgent"
    period              = var.period
    threshold           = var.threshold
    statistic           = "Average"
    alarm_description   = "memory used percent for the java proxy"
    alarm_actions       = ["${aws_sns_topic.java_proxy_alarms.arn}"]

    dimensions = {
        InstanceId = module.app_server.instance_id
    }
}
