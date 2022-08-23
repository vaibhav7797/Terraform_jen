##### Region #####
region = "eu-west-1"

##### lables #####
environment = "prod"
label_order = ["name", "environment"]

##### networking #####
vpc_cidr_block                  = "10.20.0.0/16"
availability_zones              = ["us-east-1a", "us-east-1b", "us-east-1c"]
type                            = "public-private"
assign_ipv6_address_on_creation = false

