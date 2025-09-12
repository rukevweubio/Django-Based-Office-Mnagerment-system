resource "aws_security_group" "new_security" {
    vpc_id = aws_vpc.new_vpc.id

    ingress {
        from_port = 22
        to_port = 22
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "SSH open"
    }

    ingress {
        from_port = 80
        to_port = 80
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "HTTP"
    }

    ingress {
        from_port = 8000
        to_port = 8000
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "app "
    }

    egress {
        from_port = 0
        to_port = 0
        protocol = "tcp"
        cidr_blocks = [ "0.0.0.0/0" ]
        description = "all acess"
    }

    tags = {
      Name = "${var.name}-security-group"
    }
}