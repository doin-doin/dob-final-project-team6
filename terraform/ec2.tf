# ec2.tf
resource "aws_instance" "EC2_instance_02" {
  ami                         = "ami-0c9c942bd7bf113a2"
  instance_type               = "t2.nano"
  # subnet_id                   = aws_subnet.default[0].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.OpenSG_443.id]
  iam_instance_profile =  aws_iam_instance_profile.SSMInstanceProfile.name

  tags = {
    "Name" = "ec2-01",
    "TEST" = "ec2-01",
    "Env"  = "Prod",
    "Type" = "Database",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}

resource "aws_instance" "EC2_instance_01" {
  ami                         = "ami-0c9c942bd7bf113a2"
  instance_type               = "t2.nano"
  # subnet_id                   = aws_subnet.default[3].id
  associate_public_ip_address = "true"
  vpc_security_group_ids = [aws_security_group.OpenSG_443.id]
  iam_instance_profile =  aws_iam_instance_profile.SSMInstanceProfile.name

  tags = {
    "Name" = "ec2-02",
    "TEST" = "ec2-02",
    "Env"  = "Prod",
    "Type" = "Database",
    "Owner"= "DevOps",
    "Privacy" = "Y"
  }
}
