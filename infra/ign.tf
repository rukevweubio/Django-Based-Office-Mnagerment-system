resource "aws_internet_gateway" "new_gateway" {
    vpc_id = aws_vpc.new_vpc.id
}