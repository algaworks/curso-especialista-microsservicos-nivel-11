# ---------------------------------------------------------
# Aula 42: Debugging
#
# Variáveis de ambiente para controle de log:
#
#   export TF_LOG=DEBUG          → logs detalhados
#   export TF_LOG=TRACE          → logs mais verbosos
#   export TF_LOG=INFO           → informativo
#   export TF_LOG=ERROR          → apenas erros
#   export TF_LOG_PATH=./tofu.log  → salvar em arquivo
#
# Comandos úteis:
#   tofu validate        → valida sintaxe dos arquivos .tf
#   tofu fmt             → formata os arquivos
#   tofu fmt -check      → verifica formatação (CI/CD)
#   tofu console         → REPL interativo para testar expressões
#
# No console:
#   > var.project_name
#   > local.common_tags
#   > [for k, v in var.subnets : "${k} = ${v}"]
# ---------------------------------------------------------
