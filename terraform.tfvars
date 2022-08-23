##### Region #####
region = "eu-west-1"

##### lables #####
environment = "prod"
label_order = ["name", "environment"]

##### networking #####
vpc_cidr_block                  = "10.20.0.0/16"
availability_zones              = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
type                            = "public-private"
assign_ipv6_address_on_creation = false

