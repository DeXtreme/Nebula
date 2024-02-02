data "aws_ami" "ami" {
  most_recent = true

  owners      = ["amazon"]
  
  filter {
    name   = "architecture"
    values = ["arm64"]
  }
  filter {
    name   = "name"
    values = ["al2023-ami-2023*"]
  }
}


resource "aws_instance" "jumpbox" {
  ami = data.aws_ami.ami.id
  instance_type = "t2.micro"
  subnet_id = module.vpc.private_subnets[0]
  iam_instance_profile = aws_iam_instance_profile.ssm.name

  tags = {
    Terraform = true
  }
}


