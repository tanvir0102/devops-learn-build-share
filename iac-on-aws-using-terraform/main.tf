# --- root/main.tf --- 

# Deploy Networking Resources
module "network-vpc" {
  source                        = "./network-vpc"
  access_ip                     = var.access_ip
  doa_vpc_cidr                  = var.doa_vpc_cidr
  doa_subnet_web01_public_cidr  = var.doa_subnet_web01_public_cidr
  doa_subnet_web02_public_cidr  = var.doa_subnet_web02_public_cidr
  doa_subnet_app01_private_cidr = var.doa_subnet_app01_private_cidr
  doa_subnet_app02_private_cidr = var.doa_subnet_app02_private_cidr
  doa_subnet_db01_private_cidr  = var.doa_subnet_db01_private_cidr
  doa_subnet_db02_private_cidr  = var.doa_subnet_db02_private_cidr
}