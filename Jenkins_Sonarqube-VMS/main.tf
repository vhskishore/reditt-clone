resource "aws_instance" "web" {
  ami   = "ami-06aa3f7caf3a30282"
  instance_type = "t2.large"
  key_name = "itsmeekishore"
  vpc_security_group_ids = [aws_security_group.Jenkins-VM-SG.id]
  user_data = templatefile("./install.sh", {})
  tags = {
    Name    =   "Jenkins-SonarQube"
  }
  root_block_device {
    volume_size = 40
  }
}

resource "aws_security_group" "Jenkins-VM-SG" {
  name = "Jenkins-VM-SG"
  description = "Allow TLS Inbound Traffic"
  ingress = [
    for port in [22, 80, 443, 80, 9000, 3000] : {
        description = "Inbound Rules"
        from_port   = port
        to_port     = port
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
        ipv6_cidr_blockeys  =   []
        prefix_list_ids =   []
        security_groups =   []
        self    =   false
    }
  ]

  egress = {
    from_port   =   0
    to_port     =   0
    protocol    =   "-1"
    cidr_blocks =   ["0.0.0.0/0"]
  }

  tags = {
    Name = "Jenkins-VM-SG"
  }
}