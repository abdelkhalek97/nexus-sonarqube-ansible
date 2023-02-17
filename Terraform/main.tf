module "vpc" {
  source               = "./Vpc"
  vpc-cidr             = "10.0.0.0/16"
  vpc-name             = "terraform"
  subnet_cidrs_public  = { public1 : "10.0.0.0/24", public2 : "10.0.2.0/24" }
  subnet_cidrs_private = { private1 : "10.0.1.0/24", private2 : "10.0.3.0/24" }

}
module "internetgateway1" {
  source              = "./internetGateway"
  internetgatewayName = "Terraform internetgateway"
  vpcid               = module.vpc.vpc_id

}

module "natG" {
  source         = "./natGateway"
  dependency     = module.internetgateway1.ig-id
  publicSubnetId = module.vpc.pup_subnet_id[0]

}

module "routing_public" {
  source              = "./routeTable"
  vpcid               = module.vpc.vpc_id
  internetGatewayName = module.internetgateway1.ig-id
  tableName           = "public Route Table"
  subnet_ids          = module.vpc.pup_subnet_id
}

module "routing_private" {
  source         = "./routeTable"
  vpcid          = module.vpc.vpc_id
  natGatewayName = module.natG.nat_id
  tableName      = "private Route Table"
  subnet_ids     = module.vpc.priv_subnet_id
}

module "securityGroup" {
  source               = "./SecurityGroup"
  vpcid                = module.vpc.vpc_id
  pup-cidr             = "0.0.0.0/0"
  sg_name              = "security_group"
  sg_description       = "security_group"
  sg_from_port_ingress = 22
  sg_to_port_ingress   = 80
  sg_protocol_ingress  = "tcp"
  sg_from_port_egress  = 0
  sg_to_port_egress    = 0
  sg_protocol_egress   = "-1"
}

module "jump-host" {
  source                 = "./Ec2"
  instType               = "t3.xlarge"
  subnet_ids             = module.vpc.pup_subnet_id[1]
  secg_id                = module.securityGroup.sg_id
  name                   = "jump-host"
  key_name               = "iti"

}


module "privateEc2" {
  source          = "./ec2Private"
  instType_priv   = "t3.xlarge"
  subnet_ids_priv = module.vpc.priv_subnet_id
  secg_id_priv    = module.securityGroup.sg_id
  name_priv       = "private"
  key_name_priv   = "iti"


}


module "ApplicationLB" {
  source             = "./APPloadBalancer"
  ec2ids             = module.privateEc2.instance_id_priv
  vpcid              = module.vpc.vpc_id
  attach_target_port_1 = 8081
  attach_target_port_2 = 9000
  target_name        = "application"
  target_port        = 80
  target_protocol    = "HTTP"
  health_protocol    = "HTTP"
  name               = "ALB"
  sg_id              = module.securityGroup.sg_id
  subnets            = module.vpc.priv_subnet_id
  lb_internal        = false
  listener_port      = 80
  listener_protocol  = "HTTP"
}