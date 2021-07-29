CI/CD<br />

Dockerized Python and .NET Core apps<br />

I use **Packer** to bake images for Jenkins main and agent instances based on Amazon Linux 2, files are in **master** and **worker** folders, **Groovy** scripts automate Jenkins configuration like plugins installation, automative Jenkins user and agent creation, **terraform** folder is for **Terraform** tool, consists of **IaC** templates for **AWS**:<br />
- **vpc.tf** - VPC for managing Jenkins within it<br />
- **variables.tf** - variables bring flexibility to templates for **IaC**, this file contains their declaration and default values of few of them<br />
- **variables.tfvars** - provides variables's values for the runtime which aren't specified by default<br />
- **subnets.tf** - specifies two subnets within defined VPC for main and agent Jenkins instances<br />
- **public_rt.tf** - a route table with the IGW attached to the VPC, all traffic goes to the IGW, this table's associated with public subnets in the VPC for traffic routing to the IGW, that comes from these subnets<br />
- **private_rt.tf** - defines a NAT Gateway inside a public subnet, Elastic IP address's associated with this NAT Gateway, a private route table forwards all traffic to the NAT Gateway, private subnets assigned to the private route table<br />
- **bastion.tf** - specifies a jump box, which provides secure access to EC2 instances located in private subnets, it's deployed in a public subnet and has access to private instances via SSH, based on Amazon Linux 2, SSH isn't allowed to EC2 instances, that's why a security group's associated with the executing instance, the group inbounds traffic on port 22 from anywhere<br />
- **outputs.tf** - prints the bastion public IP address and the load balancer DNS URL to the console<br />
- **jenkins_master.tf** - defines the Jenkins main instance within a private subnet with the AMI baked by **Packer**, a security group attached to this instance to allow SSH from bastion and inbound traffic on port 8080 from VPC CIDR block, also defines a public load balancer in front of the instance, which accepts HTTP traffic on port 80 and forwards it to the instance on port 8080 and automatically stops sending traffic to the Jenkins instance if it's unhealthy, a security group allows the load balancer to accept incoming HTTP traffic from anywhere<br />

**Jenkins** builds images and pushes them to the Docker Hub Registry<br />

Python app https://github.com/Therou/python_hello_world<br />

.NET Core app https://github.com/Therou/netcore_hello_world<br />