resource "aws_instance" "web" {
  ami                    = "ami-08eb150f611ca277f"   
  instance_type          = "t3.xlarge"               
  key_name               = "aws_key_pair"        
  vpc_security_group_ids = [aws_security_group.My-Jenkins-Server-SG.id]
  user_data              = file("./03_install.sh") 

  tags = {
    Name = "My-Jenkins-Server" 
  }

  root_block_device {
    volume_size = 20
  }

}


resource "aws_security_group" "My-Jenkins-Server-SG" {
  name        = "My-Jenkins-Server-SG" #
  description = "Allow TLS inbound traffic"

  ingress = [
    for port in [22, 80, 443, 8080, 9000, 3000] : {
      description      = "inbound rules"
      from_port        = port
      to_port          = port
      protocol         = "tcp"
      cidr_blocks      = ["0.0.0.0/0"]
      ipv6_cidr_blocks = []
      prefix_list_ids  = []
      security_groups  = []
      self             = false
    }
  ]

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "My-Jenkins-Server-SG"
  }

}

