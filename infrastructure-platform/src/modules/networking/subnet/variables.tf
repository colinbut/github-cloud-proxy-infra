variable "vpc_id" {
    type        = string
    description = "The id of the VPC"
}

variable "subnets" {
    type = map(object({
        availability_zone   = string
        public_ip           = bool
    }))
    description = "The subnets to create"
}