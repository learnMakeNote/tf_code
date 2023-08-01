
data "aws_vpcs" "external-connect" {
  provider = aws.external-connect

  tags = {
    "aws:cloudformation:stack-name" = "NetworkStack"
  }
}
