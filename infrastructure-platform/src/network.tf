resource "aws_eip" "app_elastic_ip_address" {
    vpc = true
}

module "app_vpc" {
    source          = "./modules/networking/vpc"
    resource_name   = "github-cloud-proxy"
}

module "app_internet_gateway" {
    source = "./modules/networking/internet-gateway"
    vpc_id = module.app_vpc.vpc_id
}

module "app_subnets" {
    source = "./modules/networking/subnet"
    
    vpc_id = module.app_vpc.vpc_id

    subnets = {
        "app_public_subnet_a" = {
            availability_zone   = "eu-west-1a"
            public_ip           = true
        }
        "app_private_subnet_a" = {
            availability_zone   = "eu-west-1a"
            public_ip           = false
        }
    }
}

module "app_route_tables" {
    source = "./modules/networking/route-table"

    vpc_id = module.app_vpc.vpc_id

    route_tables = [
        {
            cidr_block      = "0.0.0.0/0"
            gateway_id      = module.app_internet_gateway.igw_id
            resource_name   = "public-route-table"
        },
        {
            cidr_block      = "0.0.0.0/0"
            gateway_id      = module.app_nat_gateway.nat_gateway_id
            resource_name   = "private-route-table"
        }
    ]
}

module "public_route_table_association" {
    source          = "./modules/networking/route-table-association"

    subnet_id       = lookup(module.app_subnets.subnets, "_public_subnet_a").id
    route_table_id  = lookup(module.app_route_tables.route_tables, "public-route-table").id
}

module "private_route_table_association" {
    source          = "./modules/networking/route-table-association"

    subnet_id       = lookup(module.app_subnets.subnets, "_private_subnet_a").id
    route_table_id  = lookup(module.app_route_tables.route_tables, "private-route-table").id
}

module "app_nat_gateway" {
    source          = "./modules/networking/nat-gateway"

    allocation_id   = aws_eip.app_elastic_ip_address.id
    subnet_id       = lookup(module.app_subnets.subnets, "_public_subnet_a").id
    depends         = [module.app_internet_gateway.igw]
}