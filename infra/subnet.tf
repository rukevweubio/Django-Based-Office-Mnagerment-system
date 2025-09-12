resource "aws_subnet" "new_subnet" {
    vpc_id = aws_vpc.new_vpc.id
    cidr_block = "10.0.0.0/21"
    map_public_ip_on_launch = true

    tags = {
      Name = "${var.name}-subnet"
    }
}