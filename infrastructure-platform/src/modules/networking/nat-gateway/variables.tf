variable "allocation_id" {
    type        = string
    description = "The Elastic IP address Id reference"
}

variable "subnet_id" {
    type        = string
    description = "The subnet to put this NAT Gateway into"
}

variable "depends" {
    type        = list(any)
    description = "list of gateways (e.g. Internet Gateway) to depend on"
}