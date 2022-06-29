
# variable "number_of_azs" {
#   type        = number
#   description = "Number of AZ to distribute the deployment, EKS needs at least 2"
#   default     = 3
#   validation {
#     condition     = var.number_of_azs >= 2
#     error_message = "EKS deployment needs at least 2 zones"
#   }
# }

# variable "region" {
#   type        = string
#   description = "AWS region for the deployment"
#   default     = "us-west-2"
# }

# data "aws_availability_zones" "available" {
#   state = "available"
#   filter {
#     name   = "region-name"
#     values = [var.region]
#   }
# }

# resource "random_shuffle" "az" {
#   input        = keys(var.availability_zones)
#   result_count = var.number_of_azs
# }

# locals {
#   availability_zones       = zipmap(data.aws_availability_zones.available.names, data.aws_availability_zones.available.zone_ids)
#   availability_zones_names = random_shuffle.az.result
#   availability_zones_ids   = [for name in random_shuffle.az.result : var.availability_zones[name]]

# }


# output "availability_zones" {
#   value = var.availability_zones
# }

# output "availability_zones_names" {
#   value = var.availability_zones_names
# }

# output "availability_zones_ids" {
#   value = var.availability_zones_ids
# }


# locals {
#   aws_region_zones = tolist([
#     {
#       region = "us-west-2"
#       zones  = ["us-west-2a", "us-west-2b"]
#     },
#     {
#       region = "us-east-1"
#       zones  = ["us-east-1a", "us-east-2f"]
#     },
#     # When allocating new regions or zones,
#     # always add them at the end of their
#     # respective list to avoid renumbering
#     # the existing address allocations.
#   ])
# }

# module "regional" {
#   source = "hashicorp/subnets/cidr"

#   base_cidr_block = "10.0.0.0/16"
#   networks = [
#     for regional in local.aws_region_zones : {
#       name     = regional.region
#       new_bits = 8
#     }
#   ]
# }

# output "regional" {
#   value = module.regional

# }


# locals {
#   cidr_block           = "10.0.0.0/16"
#   existing_az_count    = 3
#   subnet_type_count    = 2
#   cidr_count           = local.existing_az_count * local.subnet_type_count
#   subnet_bits          = ceil(log(local.cidr_count, 2))
#   private_subnet_cidrs = [for netnumber in range(0, local.existing_az_count) : cidrsubnet(local.cidr_block, local.subnet_bits, netnumber)]
#   public_subnet_cidrs  = [for netnumber in range(local.existing_az_count, local.existing_az_count * 2) : cidrsubnet(local.cidr_block, local.subnet_bits, netnumber)]

# }

# output "pvt" {
#   value = local.private_subnet_cidrs
# }
# output "pub" {
#   value = local.public_subnet_cidrs
# }
# output "test" {
#   value = cidrsubnet("100.164.0.0/16", 4, 2)
# }


# module "pod_cidr" {
#   source = "hashicorp/subnets/cidr"

#   base_cidr_block = "100.164.0.0/16"
#   networks = [
#     {
#       name     = "Pod-1"
#       new_bits = 2 # desired - 16 (100.164.0.0/16)
#     },
#     {
#       name     = "Pod-2"
#       new_bits = 2
#     },
#     {
#       name     = "Pod-3"
#       new_bits = 2
#     },
#   ]
# }

# module "pub_cidr" {
#   source = "hashicorp/subnets/cidr"

#   base_cidr_block = "10.0.0.0/16"
#   networks = [
#     {
#       name     = "Pub-1"
#       new_bits = 11
#     },
#     {
#       name     = "Pub-2"
#       new_bits = 11
#     },
#     {
#       name     = "Pub-3"
#       new_bits = 11
#     },
#     {
#       name     = "pvt-1"
#       new_bits = 3
#     },
#     {
#       name     = "pvt-2"
#       new_bits = 3
#     },
#     {
#       name     = "pvt-3"
#       new_bits = 3
#     },
#   ]
# }


# module "pvt_cidr" {
#   source = "hashicorp/subnets/cidr"

#   base_cidr_block = "10.0.0.0/16"
#   networks = [
#     {
#       name     = "Pub-1"
#       new_bits = 3
#     },
#     {
#       name     = "Pub-2"
#       new_bits = 3
#     },
#     {
#       name     = "Pub-3"
#       new_bits = 3
#     },
#   ]
# }

# output "pod_cidr" {
#   value = module.pod_cidr
# }
# output "pub_cidr" {
#   value = module.pub_cidr
# }

# variable "availability_zones" {
#   default = ["us-west-2a", "us-west-2b", "us-west-2c"]
# }

# variable "pod_base_cidr_block" {
#   default = "100.164.0.0/16"

#   validation {
#     condition = (
#       try(cidrhost(var.pod_base_cidr_block, 0), null) == regex("^(.*)/", var.pod_base_cidr_block)[0] &&
#       try(cidrnetmask(var.pod_base_cidr_block), null) == "255.255.0.0"
#     )
#     error_message = "Argument pod_base_cidr_block must be a valid CIDR block."
#   }
# }

# variable "base_cidr_block" {
#   default = "10.0.0.0/16"
# }

# variable "public_cidr_mask" {
#   default = 27
# }

# variable "private_cidr_mask" {
#   default = 19
# }



# locals {
#   availability_zones_number = length(var.availability_zones)
#   pod_new_bits_value        = 2
#   pod_new_bits_list         = [for n in range(0, local.availability_zones_number) : local.pod_new_bits_value]
#   pod_subnets_idx           = cidrsubnets(var.pod_base_cidr_block, local.pod_new_bits_list...)
#   pod_subnets               = [for i, az in var.availability_zones : { "name" = "${var.deploy_id}-PodSubnet-${az}-${i + 1}", "cidr_block" = local.pod_subnets_idx[i] }]

#   base_cidr_mask = tonumber(regex("[^/]*$", var.base_cidr_block))
#   # ...local.availability_zones_number * 2)--> we have 2 types private and public subnets
#   new_bits_list = sort([for n in range(0, local.availability_zones_number * 2) : (n % 2 == 0 ? var.private_cidr_mask - local.base_cidr_mask : var.public_cidr_mask - local.base_cidr_mask)])
#   subnets_idx   = cidrsubnets(var.base_cidr_block, local.new_bits_list...)

#   # get the public subnets by matching the mask and populating its params
#   public_subnets = [for i, sn in local.subnets_idx : { "cidr_block" = sn, "zone" = var.availability_zones[i % (i / local.availability_zones_number)], "name" = "${var.deploy_id}-PublicSubnet-${var.availability_zones[i % (i / local.availability_zones_number)]}-${i + 1}", "type" = "public" } if length(regexall(".*/${var.public_cidr_mask}.*", sn)) > 0]

#   # get the private subnets by matching the mask and populating its params
#   private_subnets = [for i, sn in local.subnets_idx : { "cidr_block" = sn, "zone" = var.availability_zones[i % (i / local.availability_zones_number)], "name" = "${var.deploy_id}-PrivateSubnet-${var.availability_zones[i % (i / local.availability_zones_number)]}-${i % (i / local.availability_zones_number) + 1}", "type" = "private" } if length(regexall(".*/${var.private_cidr_mask}.*", sn)) > 0]
# }


# output "pod_subnets" {
#   value = local.pod_subnets
# }

# output "public_subnets" {
#   value = local.public_subnets
# }

# output "private_subnets" {
#   value = var.private_subnets
# }

# output "test" {
#   value = regex("^(.*)/", "10.0.0.0/16")[0]
# }
# output "testcidr" {
#   value = cidrhost("10.0.0.0/16", 0)
# }
# ^.*?(?=/)
# ^(.*)\n

# valid module test
# variable "availability_zones" {
#   type    = list(string)
#   default = ["us-west-2a", "us-west-2b", "us-west-2c"]
#   validation {
#     condition = (
#       length(distinct(var.availability_zones)) == length(var.availability_zones)
#     )
#     error_message = "Argument availability_zones must not contain duplicates"
#   }
# }

# variable "pod_base_cidr_block" {
#   type    = string
#   default = "100.164.0.0/16"
#   validation {
#     condition = (
#       try(cidrhost(var.pod_base_cidr_block, 0), null) == regex("^(.*)/", var.pod_base_cidr_block)[0] &&
#       try(cidrnetmask(var.pod_base_cidr_block), null) == "255.255.0.0"
#     )
#     error_message = "Argument pod_base_cidr_block must be a valid CIDR block."
#   }
# }

# variable "base_cidr_block" {
#   type    = string
#   default = "10.0.0.0/16"
#   validation {
#     condition = (
#       try(cidrhost(var.base_cidr_block, 0), null) == regex("^(.*)/", var.base_cidr_block)[0] &&
#       try(cidrnetmask(var.base_cidr_block), null) == "255.255.0.0"
#     )
#     error_message = "Argument base_cidr_block must be a valid CIDR block."
#   }
# }


# variable "pod_cidr_mask" {
#   type    = number
#   default = 18
# }

# variable "public_cidr_mask" {
#   type    = number
#   default = 27
# }

# variable "private_cidr_mask" {
#   type    = number
#   default = 19
# }

# variable "deploy_id" {
#   type        = string
#   description = "Domino Deployment ID"
#   default     = "mh-tf-eks-mod"

#   validation {
#     condition     = can(regex("^[a-z-0-9]{3,32}$", var.deploy_id))
#     error_message = "Argument deploy_id must: start with a letter, contain lowercase alphanumeric characters(can contain hyphens[-]) with length between 3 and 32 characters."
#   }
# }

# module "subnets" {
#   source                    = "../submodules/cidr-subnets"
#   pod_base_cidr_block       = var.pod_base_cidr_block
#   base_cidr_block           = var.base_cidr_block
#   public_cidr_network_bits  = var.public_cidr_mask
#   private_cidr_network_bits = var.private_cidr_mask
#   subnet_name_prefix        = var.deploy_id
# }

# output "subnets" {
#   value = module.subnets_cidr
# }

# locals {
#   pod_new_bits_list      = [for n in range(0, 4) : 18 - 16]
#   pod_subnet_cidr_blocks = cidrsubnets("100.164.0.0/16", local.pod_new_bits_list...)
# }


# output "name" {
#   value = local.pod_subnet_cidr_blocks

# }

# variable "base_cidr_block" {
#   type    = string
#   default = "10.0.0.0/16"
#   validation {
#     condition = (
#       try(cidrhost(var.base_cidr_block, 0), null) == regex("^(.*)/", var.base_cidr_block)[0] &&
#       try(cidrnetmask(var.base_cidr_block), null) == "255.255.0.0"
#     )
#     error_message = "Argument base_cidr_block must be a valid CIDR block."
#   }
# }


# output "pods_sb" {
#   description = "Map containing the CIDR information for the private subnets"
#   value       = local.pod_subnet_cidr_blocks
#   #   condition = alltrue([
#   #     for s in local.pod_subnet_cidr_blocks :
#   #       try(cidrhost(s.cidr_block, 0), null) == regex("^(.*)/", s.cidr_block)[0] &&
#   #        try(cidrnetmask(s.cidr_block), null) == "255.255.0.0"
#   #     )
#   #   ])
#   #   error_message = "There is an invalid CIDR block"
#   # }
# }


variable "instance_types" {
  type = list(string)
  default = [
    "m5.2xlarge",
    "m5.4xlarge",
    "g4dn.xlarge"
  ]
}

data "aws_ec2_instance_type_offerings" "instance_types" {
  for_each = toset(var.instance_types)
  filter {
    name   = "instance-type"
    values = [each.key]
  }
  location_type = "availability-zone-id"
}


output "instance_azs" {
  value = { for k, v in data.aws_ec2_instance_type_offerings.instance_types : k => toset(v.locations) }
}
