data "aws_availability_zones" "available"{
    state="available"
}


data "aws_vpc" "default"{

    default=true
}

data "aws_route_table" "default"{
    route_table_id = data.aws_vpc.default.main_route_table_id
}