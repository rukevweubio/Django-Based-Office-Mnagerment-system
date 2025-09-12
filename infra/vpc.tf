resource "aws_vpc" "new_vpc" {
    cidr_block = "10.0.0.0/17"

    tags = {
      Name = "${var.name}-vpc"
    }
}