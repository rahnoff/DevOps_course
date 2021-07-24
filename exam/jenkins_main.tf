resource "aws_instance" "jenkins_main" {
ami = data.aws_ami.jenkins-main.id
instance_type = var.jenkins_master_instance_type
key_name = aws_key_pair.management.id
vpc_security_group_ids = [aws_security_group.jenkins_master_sg.id]
subnet_id = element(aws_subnet.private_subnets, 0)

root_block_device {
volume_type = "gp3"
volume_size = 8
delete_on_termination = false
}

tags = {
Name = "jenkins_main"
Author = var.author
}

data "aws_ami" "jenkins_main" {
most_recent = true
owners = ["self"]

filter {
name = "name"
values = ["jenkins_main"]
}

resource "aws_security_group" "jenkins_main_sg" {
name = "jenkins_main_sg"
description = "Allow traffic on port 8080 and enable SSH"
vpc_id = aws_vpc.management.id

ingress {
from_port = "22"
to_port = "22"
protocol = "tcp"
security_groups = [aws_security_group.bastion_host.id]
}

ingress {
from_port = "8080"
to_port = "8080"
protocol = "tcp"
cidr_blocks = [var.cidr_block]
}

egress {
from_port = "0"
to_port = "0"
protocol = "-1"
cidr_blocks = ["0.0.0.0/0"]
}

tags = {
Name = "jenkins_main_sg"
Author = var.author
}

}
}
}
