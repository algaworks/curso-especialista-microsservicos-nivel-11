output "ami_id" {
  description = "ID da AMI Ubuntu 22.04 LTS mais recente"
  value       = data.aws_ami.ubuntu.id
}

output "ami_name" {
  description = "Nome da AMI selecionada"
  value       = data.aws_ami.ubuntu.name
}
