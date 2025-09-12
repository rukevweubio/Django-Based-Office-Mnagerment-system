resource "aws_route_table" "new_route" {
    vpc_id = aws_vpc.new_vpc.id

    route {
        gateway_id = aws_internet_gateway.new_gateway.id
        cidr_block = "0.0.0.0/0"
    }

    tags = {
      Name = "${var.name}-rt"
    }
}

resource "aws_route_table_association" "new_association" {
    subnet_id = aws_subnet.new_subnet.id
    route_table_id = aws_route_table.new_route.id
}