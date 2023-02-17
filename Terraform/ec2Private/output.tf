output "instance_id_priv" {
  value = tolist(aws_instance.ec2_priv.*.id)
}

output "instance_ip_priv" {
  value = tolist(aws_instance.ec2_priv.*.private_ip)
}
