resource "aws_key_pair" "new_key" {
    key_name   = "${var.name}-key"
    public_key = "${file("new_key.pub")}"
}

resource "aws_instance" "new_instance" {
    ami = var.ami
    instance_type = var.instance_type


    tags = {
      Name = "${var.name}-instance"
    }
}