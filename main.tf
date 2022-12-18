# ---------------VPC---------------
resource "aws_vpc" "example" {
  cidr_block="10.0.0.0/16"
  enable_dns_support=true
  enable_dns_hostnames=true

  tags={
    Name="example"
  }
}

module "web_server" {
  source="./http_server"
  instance_type="t3.micro"
}

module "describe_regions_for_ec2" {
  source="./iam_role"
  name="describe-regions-for-ec2"
  identifier="ec2.amazonaws.com"
  policy=data.aws_iam_policy_document.assume_role.json
}

module "example_sg" {
  source="./security_group"
  name="module-sg"
  vpc_id=aws_vpc.example.id
  port=80
  cidr_blocks=["0.0.0.0/0"]
}

module "http_sg" {
  source="./security_group"
  name="http-sg"
  vpc_id=aws_vpc.example.id
  port=80
  cidr_blocks=["0.0.0.0/0"]
}

module "https_sg" {
  source="./security_group"
  name="https-sg"
  vpc_id=aws_vpc.example.id
  port=443
  cidr_blocks=["0.0.0.0/0"]
}

module "http_redirect_sg" {
  source="./security_group"
  name="http-redirect--sg"
  vpc_id=aws_vpc.example.id
  port=8080
  cidr_blocks=["0.0.0.0/0"]
}

output "public_dns" {
  value=module.web_server.public_dns
}
