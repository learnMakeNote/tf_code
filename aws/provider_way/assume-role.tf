# user is in A account,
# create role in B account relate to user in A account
# use this role create vpc resource in B account

#provider "aws" {
#  assume_role {
#    role_arn = "arn:aws:iam::281078304032:role/testAssumeRole"
#    external_id = "testcode"
#  }
#}