# ---------------------------------------------------------
# Aula 43: Null Resource
#
# null_resource não gerencia nenhum recurso real na nuvem,
# mas permite executar provisioners (local-exec, remote-exec)
# e acionar lógica extra durante o apply.
#
# Caso de uso comum: executar um script de bootstrap na EC2
# ou invalidar um cache após deploy.
# ---------------------------------------------------------

resource "null_resource" "bootstrap_bastion" {
  # triggers: define quando o null_resource deve re-executar
  triggers = {
    bastion_ip = var.bastion_ip
  }

  # Executa um comando SSH no Bastion após criação
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update -y",
      "sudo apt-get install -y curl unzip",
      "echo 'Bootstrap concluído!'",
    ]

    connection {

      type = "ssh"

      host = var.bastion_ip

      user = "ubuntu"

      private_key = file(var.key_path)

    }
  }
}

# Alternativa: local-exec — roda no computador local
resource "null_resource" "local_notification" {
  triggers = {
    bastion_ip = var.bastion_ip
  }

  provisioner "local-exec" {
    command = "echo 'Bastion disponível em: ${var.bastion_ip}'"
  }
}
