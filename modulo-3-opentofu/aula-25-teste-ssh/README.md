# ---------------------------------------------------------
# Aula 25: Teste SSH
#
# Para conectar ao Bastion com Agent Forwarding:
#   ssh-add algadelivery.pem
#   ssh -A ubuntu@<bastion_public_ip>
#
# A partir do Bastion, conectar na EC2 privada:
#   ssh ubuntu@<private_instance_private_ip>
#
# Dicas:
#   - Use ssh-add para adicionar sua chave ao agente SSH local
#   - O flag -A habilita agent forwarding para repassar a chave
#   - Nunca copie a chave PEM para o Bastion!
# ---------------------------------------------------------

# Este arquivo reutiliza o mesmo código da aula-24.
# Os arquivos provider.tf, variables.tf, locals.tf e main.tf
# são idênticos à aula anterior.
#
# Após o apply, consulte os outputs:
#   tofu output bastion_public_ip
#   tofu output private_instance_private_ip
