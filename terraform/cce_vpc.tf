resource "aws_default_vpc" "default" {
  tags = {
    Name = "Default-VPC"
  }
}

# #endpoint.tf
# resource "aws_vpc_endpoint" "SSM_endpoint" {
#   vpc_id       = aws_default_vpc.default.id
#   service_name = "com.amazonaws.ap-northeast-2.ssm"

#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.OpenSG_443.id]
#   # subnet_ids         = [
#   #   aws_subnet.default[0].id,
#   #   aws_subnet.default[3].id
#   # ]

#   tags = {
#     Name = "VPC-endpoint-SSM",
#     TEST = "VPC-endpoint-SSM"
#   }
# }

# resource "aws_vpc_endpoint" "SSM_Messages_endpoint" {
#   vpc_id       = aws_default_vpc.default.id
#   service_name = "com.amazonaws.ap-northeast-2.ssmmessages"

#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.OpenSG_443.id]
#   # subnet_ids         = [
#   #   aws_subnet.default[0].id,
#   #   aws_subnet.default[3].id
#   # ]

#   tags = {
#     Name = "VPC-endpoint-SSM-Messages",
#     TEST = "VPC-endpoint-SSM-Messages"
#   }
# }

# resource "aws_vpc_endpoint" "EC2_Messages_endpoint" {
#   vpc_id       = aws_default_vpc.default.id
#   service_name = "com.amazonaws.ap-northeast-2.ec2messages"

#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.OpenSG_443.id]
#   # subnet_ids         = [
#   #   aws_subnet.default[0].id,
#   #   aws_subnet.default[3].id
#   # ]

#   tags = {
#     Name = "VPC-endpoint-EC2-Messages",
#     TEST = "VPC-endpoint-EC2-Messages"
#   }
# }

# resource "aws_vpc_endpoint" "logs_endpoint" {
#   vpc_id       = aws_default_vpc.default.id
#   service_name = "com.amazonaws.ap-northeast-2.logs"

#   vpc_endpoint_type = "Interface"

#   security_group_ids = [aws_security_group.OpenSG_443.id]
#   # subnet_ids         = [
#   #   aws_subnet.default[0].id,
#   #   aws_subnet.default[3].id
#   # ]

#   tags = {
#     Name = "VPC-endpoint-logs",
#     TEST = "VPC-endpoint-logs"
#   }
# }
