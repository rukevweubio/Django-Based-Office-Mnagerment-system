variable "name" {
  description = "Name of every resource"
  type        = string
  default     = "session"
}



variable "instance_type" {
    default = "t2.micro"
    type = string
    description = "this is the instance type"
  
}

variable "volume_size" {
    default = 10
    type = number
    description = "this is the volume size of the instance"
}

variable "volume_type" {
    default = "gp3"
    type = string
}

variable "ami" {
    default = "ami-020cba7c55df1f615"
    type = string
    description = "amazon machine image "
  
}
