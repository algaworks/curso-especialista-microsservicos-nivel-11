# ---------------------------------------------------------
# Aula 41: State avançado
#
# Comandos de state:
#   tofu state list                    → lista todos os recursos
#   tofu state show <recurso>          → detalha um recurso
#   tofu state mv <origem> <destino>   → renomeia recurso no state
#   tofu state rm <recurso>            → remove do state (não destrói!)
#   tofu state pull                    → baixa state remoto
#   tofu state push                    → envia state local para remoto
#
# Exemplos práticos:
#
# Renomear recurso após refatoração:
#   tofu state mv aws_instance.bastion module.ec2.aws_instance.bastion
#
# Remover recurso do controle do OpenTofu (sem destruir na AWS):
#   tofu state rm aws_instance.temporary
#
# Mover recurso entre states (workspaces/stacks diferentes):
#   tofu state pull > state_origem.json
#   tofu state push state_origem.json  (no destino)
# ---------------------------------------------------------
