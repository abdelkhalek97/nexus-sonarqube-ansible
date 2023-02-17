resource "local_file" "tf_ansible_vars_file_new" {
  content = <<EOF
  [bastion]
   bastion ansible_host=${module.jump-host.instance_id} ansible_user=ubuntu ansible_ssh_private_key_file=./iti.pem
  [private]
   nexus ansible_host=${module.privateEc2.instance_ip_priv[0]} ansible_user=ubuntu ansible_ssh_private_key_file=./iti.pem ansible_ssh_common_args='-o ProxyCommand="ssh bastion -W %h:%p"'
   sonarqube ansible_host=${module.privateEc2.instance_ip_priv[1]} ansible_user=ubuntu ansible_ssh_private_key_file=./iti.pem ansible_ssh_common_args='-o ProxyCommand="ssh bastion -W %h:%p"'
  EOF
  filename = "../inventory.txt"
}
