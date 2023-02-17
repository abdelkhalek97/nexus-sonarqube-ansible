resource "aws_instance" "ec2_priv" {
  ami                    = "ami-0557a15b87f6559cf"
  instance_type          = var.instType_priv
  count                  = length(var.subnet_ids_priv)
  subnet_id              = var.subnet_ids_priv[count.index]
  vpc_security_group_ids = [var.secg_id_priv]
  key_name               = var.key_name_priv
  associate_public_ip_address = "false"

  tags = {
    Name = "${var.name_priv} ${count.index + 1}"
  }
}


