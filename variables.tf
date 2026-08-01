variable "project"{
  type= string

}

variable "environment"{
  type= string
  
}

variable "vpc_cidr"{
  type= string
  default="10.0.0.0/16"
}

variable "vpc_tags"{

  type= map
  default= {}

}

variable "igw_gateway"{
   type= map
   default={}
}

variable "public_subnet_cidr"{
  type=list
  default=["10.0.1.0/24" , "10.0.2.0/24"]
}

variable "public_subnet_tags"{
  type=map
  default={}
}

variable "private_subnet_cidr"{
  type=list
  default=["10.0.11.0/24" , "10.0.12.0/24"]
}

variable "private_subnet_tags"{
  type=map
  default={}
}

variable "database_subnet_cidr"{
  type=list
  default=["10.0.21.0/24" , "10.0.22.0/24"]
}

variable "database_subnet_tags"{
  type=map
  default={}
}

variable "public_route_table_tags"{
  type=map
  default= {}
}

variable "private_route_table_tags"{
  type=map
  default= {}
}

variable "database_route_table_tags"{
  type=map
  default= {}
}

variable "eip_tags"{
  type=map
  default={}
}

variable "nat_gateway_tags"{
  type=map
  default={}
}

# variable "is_peering_required"{
#   default= {}
#   type=map
  
# }

variable "is_peering_required" {
  type    = bool
  default = false
}


variable "vpc_peering_tags"{
  type=map
  default={}
}