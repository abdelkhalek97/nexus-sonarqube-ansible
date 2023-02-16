resource "aws_instance" "jump-host" {
 ami           = "ami-0557a15b87f6559cf"
 instance_type = "t3.micro"
 associate_public_ip_address = true
 subnet_id = aws_subnet.bastion.id
 vpc_security_group_ids = [aws_security_group.pub-secgroup.id]
 key_name = "iti"

 tags = {
    Name = "jumphost"
  }

}

resource "aws_instance" "private-ec2-1" {
 ami           = "ami-0557a15b87f6559cf"
  instance_type = "t3.micro"
  associate_public_ip_address = false
  subnet_id = aws_subnet.private-sub1.id
  vpc_security_group_ids = [aws_security_group.pub-secgroup.id]
  key_name = "iti"
  # bastion_host_ip = aws_instance.jump-host.public_ip
  tags = {
    Name = "sonarqube"
  }
  

}

resource "aws_instance" "private-ec2-2" {
 ami           = "ami-0557a15b87f6559cf"
  instance_type = "t3.micro"
  associate_public_ip_address = false
  subnet_id = aws_subnet.private-sub2.id
  vpc_security_group_ids = [aws_security_group.pub-secgroup.id]
  # bastion_host_ip = aws_instance.jump-host.public_ip
  key_name = "iti"
  tags = {
    Name = "nexus"
  }
  
}



resource "local_file" "tf_ansible_vars_file_new" {
  content = <<EOF
  [bastion]
  bastion ansible_host=${aws_instance.jump-host.public_ip} ansible_user=ubuntu ansible_port=22 ansible_private_key_file=./iti.pem
  [private]
  nexus ansible_host=${aws_instance.private-ec2-2.private_ip} ansible_user=ec2-user ansible_port=22 ansible_private_key_file=./iti.pem ansible_ssh_common_args='-o ProxyCommand="ssh bastion -W %h:%p"'
  sonarqube ansible_host=${aws_instance.private-ec2-1.private_ip} ansible_user=ubuntu ansible_port=22 ansible_private_key_file=./iti.pem ansible_ssh_common_args='-o ProxyCommand="ssh bastion -W %h:%p"'
  EOF
  filename = "../inventory.txt"
}
