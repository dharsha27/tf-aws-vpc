resource "aws_vpc" "main"{
    cidr_block=var.vpc_cidr
    instance_tenancy="default"
    enable_dns_hostnames=true

    tags= merge(
        var.vpc_tags,
        local.common_tags
    )
}

resource "aws_internet_gateway" "main"{
    vpc_id=aws_vpc.main.id
    tags = merge (
        var.igw_gateway,
        local.common_tags
    )

    
}

#  creating the subnets public and private and database

resource "aws_subnet" "public"{
    count=length(var.public_subnet_cidr)
    vpc_id=aws_vpc.main.id
    cidr_block=trimspace(var.public_subnet_cidr[count.index])
    availability_zone=local.az_info[count.index]
    map_public_ip_on_launch=true

     tags=merge(
        var.public_subnet_tags,
        local.common_tags,
        {
            Name = "${local.common_name}-public-${split("-",local.az_info[count.index])[2] }"
        }
    )

}

resource "aws_subnet" "private"{
    count=length(var.private_subnet_cidr)
    vpc_id=aws_vpc.main.id
    cidr_block=trimspace(var.private_subnet_cidr[count.index])
    availability_zone=local.az_info[count.index]
    map_public_ip_on_launch=false

    tags=merge(
        var.private_subnet_tags,
        local.common_tags,
        {
            Name = "${local.common_name}-private-${split("-",local.az_info[count.index])[2] }"
        }
    )
    
}

resource "aws_subnet" "database"{
    count=length(var.database_subnet_cidr)
    vpc_id=aws_vpc.main.id
    cidr_block=trimspace(var.database_subnet_cidr[count.index])
    availability_zone=local.az_info[count.index]
    map_public_ip_on_launch=false

    tags=merge(
        var.database_subnet_tags,
        local.common_tags,
        {
            Name = "${local.common_name}-database-${split("-",local.az_info[count.index])[2] }"
        }
    )
    
}

#  creating the route tables

resource "aws_route_table" "public"{
    vpc_id=aws_vpc.main.id

    tags=merge(
        var.public_route_table_tags,
        local.common_tags,
        {
            Name="${local.common_name}-public"
        }

    )
   
}

resource "aws_route_table" "private"{
    vpc_id=aws_vpc.main.id

    tags=merge(
        var.private_route_table_tags,
        local.common_tags,
        {
            Name="${local.common_name}-private"
        }

    )
   
}

resource "aws_route_table" "database"{
    vpc_id=aws_vpc.main.id

    tags=merge(
        var.database_route_table_tags,
        local.common_tags,
        {
            Name="${local.common_name}-database"
        }

    )
   
}

# we are associating the route tables with subnetsids 

resource "aws_route_table_association" "public"{
    count=length(var.public_subnet_cidr)
    subnet_id=aws_subnet.public[count.index].id
    route_table_id=aws_route_table.public.id
}

resource "aws_route_table_association" "private"{
    count=length(var.private_subnet_cidr)
    subnet_id=aws_subnet.private[count.index].id
    route_table_id=aws_route_table.private.id
}

resource "aws_route_table_association" "database"{
    count=length(var.database_subnet_cidr)
    subnet_id=aws_subnet.database[count.index].id
    route_table_id=aws_route_table.database.id
}


# creating the elastic ip for NAT

resource "aws_eip" "nat"{
    domain="vpc"

    tags =merge(
    var.eip_tags,
    local.common_tags,
    {
        Name="${local.common_name}-nat"
    }

    )
}

resource "aws_nat_gateway" "main"{
    allocation_id=aws_eip.nat.id
    subnet_id=aws_subnet.public[0].id

    tags=merge(
        var.nat_gateway_tags,
        local.common_tags

    )
    depends_on=[aws_internet_gateway.main]
}

# attaching the internet gateway to the public 

resource "aws_route" "public"{
    route_table_id         =aws_route_table.public.id
    destination_cidr_block ="0.0.0.0/0"
    gateway_id=aws_internet_gateway.main.id
}

resource "aws_route" "private"{
    route_table_id         =aws_route_table.private.id
    destination_cidr_block ="0.0.0.0/0"
    nat_gateway_id=aws_nat_gateway.main.id
}

resource "aws_route" "database"{
    route_table_id         =aws_route_table.database.id
    destination_cidr_block ="0.0.0.0/0"
    nat_gateway_id=aws_nat_gateway.main.id
}