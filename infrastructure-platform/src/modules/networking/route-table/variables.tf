variable "vpc_id" {
    type        = string
    description = "The VPC id"
}

variable "route_tables" {
    type = list(object({
        cidr_block      = string
        gateway_id      = string
        resource_name   = string
    }))
    description = "Configuration options for the Route Tables"
}