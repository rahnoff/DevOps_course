                                          CI/CD<br />

                                  Python and Go projects<br />

I use **Packer** for baking two images for Jenkins main instance and agents, Debian is a base image. **main** folder contains Jenkins main instance configuration, it consists of Groovy scripts for automative user and agents creation, Packer json template, bash scripts for Jenkins and its plugins installation. **agent** folder is for Jenkins agent configuration, consists of bash script and Packer json template<br />

I use **Terraform** for making an infrastructure in **AWS**, which includes one Jenkins main instance, couple of agents, a load balancer, a bastion host as a gateway to Jenkins main instance, private and public subnets<br />
