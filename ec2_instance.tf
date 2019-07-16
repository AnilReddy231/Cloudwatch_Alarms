resource "aws_key_pair" "generated_key" {
  key_name   = "${var.env_name}_key"
  public_key = "${tls_private_key.pvt.public_key_openssh}"
}

resource "tls_private_key" "pvt" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_instance" "ec2" {
    count                = "${var.ec2_instance_id == "" ? 1 : 0}"
  ami                    = "ami-0f378490dca16e3f4"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-bd9598d7"]
  subnet_id              = "subnet-2ac03f66"
  source_dest_check      = false
  key_name               = "${aws_key_pair.generated_key.key_name}"

  root_block_device {
    volume_type = "gp2"
  }

  tags = "${merge(var.tags,
    map("Name", "${var.instance_dns}")
  )}"
}

module "ec2_alarms" {
  source          = "./EC2_ALARMS"
  ec2_instance_id = "${aws_instance.ec2.0.id}"
  alarm_emails    = "${var.alarm_emails}"
  regions         = "${var.regions}"
}