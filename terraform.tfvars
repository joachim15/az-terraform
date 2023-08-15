region = "us-east-1"


instances = {
  instance2 = {
    Hostname                       = "test"
    ami                            = "ami-005b7876121b7244d"
    instance_type                  = "t2.micro"
    vpc_security_group_ids         = ["sg-0a049006f2afb54da"]
    key_name                       = "ucar"
    subnet_id                      = "subnet-0a2377f35efc9c4c5"
    disable_api_termination        = true
    iam_instance_profile           = "test"
    associate_public_ip            = false
    ebs_root_volume_size           = 10
    ebs_root_delete_on_termination = true
    ebs_device_name                = "/dev/xvda"
    ebs_volume_size                = "5"
    ebs_volume_type                = "gp2"
    ebs_delete_on_termination      = true
    ebs_encrypted                  = true
    ebs_blocks = {
      block1 = {
        ebs_device_name           = "/dev/xvda"
        ebs_volume_size           = "5"
        ebs_volume_type           = "gp2"
        ebs_delete_on_termination = true
        ebs_encrypted             = true
      }
    }
  },
  instance1 = {
    Hostname                       = "test"
    ami                            = "ami-005b7876121b7244d"
    instance_type                  = "t2.micro"
    vpc_security_group_ids         = ["sg-0a049006f2afb54da"]
    key_name                       = "ucar"
    subnet_id                      = "subnet-0a2377f35efc9c4c5"
    disable_api_termination        = true
    iam_instance_profile           = "test"
    associate_public_ip            = false
    ebs_root_volume_size           = 10
    ebs_root_delete_on_termination = true
    ebs_blocks = {
      block1 = {
        ebs_device_name           = "/dev/xvda"
        ebs_volume_size           = "5"
        ebs_volume_type           = "gp2"
        ebs_delete_on_termination = true
        ebs_encrypted             = true
      },
      block2 = {
        ebs_device_name           = "/dev/xvdb"
        ebs_volume_size           = "10"
        ebs_volume_type           = "gp2"
        ebs_delete_on_termination = true
        ebs_encrypted             = true
      },
    }
  }
}


output "private_ip" {
    description = "Private IP Address"
    value = "${aws_instance.ec2.*.private_ip}"
}