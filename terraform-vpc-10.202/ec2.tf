# data "aws_ami" "ec2-ami" {
#   most_recent = true
#   owners = ["099720109477"] # Canonical

#   filter {
#       name   = "name"
#       # values = ["ubuntu/images/hvm-ssd/ubuntu-xenial-16.04-amd64-server-*"]
#       values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
#   }

#   filter {
#       name   = "virtualization-type"
#       values = ["hvm"]
#   }
# }


# resource "aws_instance" "ec2-instance-web1" {
#   ami           = "${data.aws_ami.ec2-ami.id}"
#   instance_type = "t2.micro"

#   associate_public_ip_address = true
#   # availability_zone           = "${var.availabilityZone}"
#   subnet_id                   = "${module.vpc.public_subnets[0]}"
#   key_name                    = "aws-instances-ec2-user"
#   # Username = "ubuntu"

#   vpc_security_group_ids = ["${aws_default_security_group.default.id}"]

#   tags = {
#     Name        = "EC2 for Ansible - web1"
#     Creator     = local.creator
#     Owner       = local.owner
#     Namespace   = local.namespace
#     Environment = local.stage
#     Usage       = local.usage

#     # Tags for Ansible are always empty.
#     Ansible-group-all  = ""
#     Ansible-group-web = ""
#   }
# }

# resource "aws_instance" "ec2-instance-web2" {
#   ami           = "${data.aws_ami.ec2-ami.id}"
#   instance_type = "t2.micro"

#   associate_public_ip_address = true
#   # availability_zone           = "${var.availabilityZone}"
#   subnet_id                   = "${module.vpc.public_subnets[0]}"
#   key_name                    = "aws-instances-ec2-user"
#   # Username = "ubuntu"

#   vpc_security_group_ids = ["${aws_default_security_group.default.id}"]

#   tags = {
#     Name        = "EC2 for Ansible - web2"
#     Creator     = local.creator
#     Owner       = local.owner
#     Namespace   = local.namespace
#     Environment = local.stage
#     Usage       = local.usage

#     # Tags for Ansible are always empty.
#     Ansible-group-all  = ""
#     Ansible-group-web = ""
#   }
# }

# resource "aws_instance" "ec2-instance-db1" {
#   ami           = "${data.aws_ami.ec2-ami.id}"
#   instance_type = "t2.micro"

#   associate_public_ip_address = true
#   # availability_zone           = "${var.availabilityZone}"
#   subnet_id                   = "${module.vpc.public_subnets[0]}"
#   key_name                    = "aws-instances-ec2-user"
#   # Username = "ubuntu"

#   vpc_security_group_ids = ["${aws_default_security_group.default.id}"]

#   tags = {
#     Name        = "EC2 for Ansible - db1"
#     Creator     = local.creator
#     Owner       = local.owner
#     Namespace   = local.namespace
#     Environment = local.stage
#     Usage       = local.usage

#     # Tags for Ansible are always empty.
#     Ansible-group-all  = ""
#     Ansible-group-db = ""
#   }
# }

# resource "aws_instance" "ec2-instance-db2" {
#   ami           = "${data.aws_ami.ec2-ami.id}"
#   instance_type = "t2.micro"

#   associate_public_ip_address = true
#   # availability_zone           = "${var.availabilityZone}"
#   subnet_id                   = "${module.vpc.public_subnets[0]}"
#   key_name                    = "aws-instances-ec2-user"
#   # Username = "ubuntu"

#   vpc_security_group_ids = ["${aws_default_security_group.default.id}"]

#   tags = {
#     Name        = "EC2 for Ansible - db2"
#     Creator     = local.creator
#     Owner       = local.owner
#     Namespace   = local.namespace
#     Environment = local.stage
#     Usage       = local.usage

#     # Tags for Ansible are always empty.
#     Ansible-group-all  = ""
#     Ansible-group-db = ""
#     Ansible-group-backup = ""
#   }
# }
