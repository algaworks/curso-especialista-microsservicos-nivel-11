<h2><strong>Objetivo</strong></h2>
<p>Reorganizar o código do EKS e do ACM em <strong>dois módulos OpenTofu</strong>, <code>modules/eks</code> e <code>modules/acm</code>, no mesmo padrão dos módulos que você usa desde o Módulo 4, e, como diferencial, levar o cluster que já está no ar para dentro desses módulos <strong>sem destruir nada</strong>.</p>

<h2><strong>Contexto</strong></h2>
<p>Na aula 6.14 o cluster EKS ficou pronto: node group, add-ons, EBS CSI Driver, AWS Load Balancer Controller e um certificado do ACM validado na Cloudflare. Funciona, mas o código cresceu do jeito que deu, e são seis arquivos soltos na raiz do projeto:</p>
<pre><code>06.14-configurando-acm-e-listener-https/
├── eks.tofu                  cluster, role do control plane, security group, log group
├── eks_node_group.tofu       node group e a role dos nodes
├── eks_addons.tofu           add-ons, OIDC provider e a role IRSA do EBS CSI
├── eks_storage_class.tofu    StorageClass gp3 default
├── eks_alb_controller.tofu   policy, role IRSA e helm_release do controller
└── acm.tofu                  certificado, records de validação na Cloudflare e a espera da validação
</code></pre>
<p>Desde o Módulo 4, todo serviço tem o seu módulo em <code>modules/</code> (<code>vpc</code>, <code>ec2</code>, <code>rds</code>, <code>elasticache</code>, <code>msk</code>), e a raiz só faz a composição. O EKS e o ACM são os únicos fora desse padrão.</p>
<p><strong>Aviso:</strong> o cluster já está no ar. No lab, dá para destruir e recriar. Em produção, isso seria derrubar todas as aplicações. Por isso o desafio tem dois caminhos, e o segundo é o que se faz de verdade.</p>

<h2><strong>Ponto de partida</strong></h2>
<p>Use o código da aula <strong>6.14</strong>, com o cluster aplicado e o Ingress com HTTPS respondendo:</p>
<p>Projeto base: <a href="https://github.com/algaworks/curso-especialista-microsservicos-nivel-11/tree/main/06.14-configurando-acm-e-listener-https" target="_blank" rel="noopener">06.14-configurando-acm-e-listener-https</a></p>
<p>Abra lado a lado um dos módulos que já existem (por exemplo <code>modules/rds/</code> e a chamada dele em <code>rds.tofu</code>) e os arquivos <code>eks*.tofu</code>. A estrutura que você vai construir é a mesma do RDS.</p>

<h2>O que você deve implementar</h2>

<h3>1. Criar o módulo <code>modules/eks/</code></h3>
<ul>
<li>Leve para dentro dele <strong>todo</strong> o conteúdo dos arquivos <code>eks*.tofu</code>.</li>
<li>Organize-o como os módulos anteriores: arquivos separados por assunto, um <code>variables.tofu</code> e um <code>outputs.tofu</code>.</li>
<li>O que vinha de fora (<code>module.vpc</code>, locals da raiz, <code>var.aws_region</code>) passa a entrar como <strong>variável do módulo</strong>. O módulo não pode referenciar nada da raiz diretamente.</li>
<li>Receba as tags por uma variável <code>common_tags</code>, como nos outros módulos.</li>
<li>Exponha como output tudo o que a raiz e os providers precisam: nome e endpoint do cluster, certificado da CA, ARN do OIDC provider, roles.</li>
</ul>

<h3>2. Criar o módulo <code>modules/acm/</code></h3>
<ul>
<li>Leve para dentro dele todo o conteúdo de <code>acm.tofu</code>.</li>
<li>Exponha como output, no mínimo, o <strong>ARN do certificado validado</strong>. É ele que vai na anotação <code>alb.ingress.kubernetes.io/certificate-arn</code> do Ingress.</li>
</ul>

<h3>3. Ajustar a raiz</h3>
<ul>
<li>No lugar dos seis arquivos, ficam só <code>eks.tofu</code> e <code>acm.tofu</code>, com as chamadas <code>module &quot;eks&quot;</code> e <code>module &quot;acm&quot;</code>.</li>
<li>Os providers <code>kubernetes</code> e <code>helm</code>, e o <code>data &quot;aws_eks_cluster_auth&quot;</code>, passam a ler os valores <strong>do módulo</strong>, e não mais dos recursos.</li>
<li>Os outputs da raiz passam a repassar os outputs dos módulos.</li>
</ul>

<h3>4. Subir o código modularizado: escolha um caminho</h3>
<p>O código novo não sabe que o cluster antigo existe. Há dois jeitos de resolver isso.</p>
<p><strong>Caminho A: recriar do zero.</strong> Destrua o ambiente da 6.14 e aplique o código novo:</p>
<pre><code># na pasta da 6.14
kubectl delete ingress --all -A          # espere o ALB sumir no Console
tofu destroy -var-file=dev.tfvars

# na pasta do desafio
tofu apply -var-file=dev.tfvars
</code></pre>
<p>Funciona, e no lab é perfeitamente aceitável. É o que <strong>não</strong> se faz com um cluster de produção: todas as aplicações caem durante a troca.</p>
<p><strong>Caminho B (opcional, o diferencial): migrar o state sem destruir nada.</strong> O cluster que está no ar passa para os módulos sem ser tocado. Use <code>tofu state mv</code> para levar cada recurso do endereço antigo (raiz) para o novo (dentro do módulo). Antes de mexer, faça um <strong>backup do state</strong> com <code>tofu state pull</code>.</p>
<p>A resolução passo a passo deste caminho está no repositório, em <a href="https://github.com/algaworks/curso-especialista-microsservicos-nivel-11/tree/main/06.15-desafio-modularizacao-eks-acm/docs/migration-eks-cluster.md" target="_blank" rel="noopener">docs/migration-eks-cluster.md</a>. Tente primeiro sozinho e use o arquivo para conferir.</p>

<h3>5. Não mudar o comportamento</h3>
<p>Modularizar é mudar a <strong>organização</strong>, não o <strong>resultado</strong>. Nenhum nome, tag, chave de <code>for_each</code> ou parâmetro pode mudar no caminho. Se você achar um bug no código original, anote-o e corrija <strong>depois</strong>, numa mudança separada.</p>

<h3>Atenção aos pontos que quebram</h3>
<p>Cada um destes quebra de um jeito diferente, e dois deles só aparecem no <code>plan</code>, quando já é tarde para quem roda <code>apply</code> sem ler:</p>
<ul>
<li><strong>Endereço novo é recurso novo.</strong> Para o OpenTofu, <code>aws_eks_cluster.main</code> e <code>module.eks.aws_eks_cluster.main</code> são recursos <strong>diferentes</strong>. Sem migrar o state, o <code>plan</code> quer criar tudo de novo dentro do módulo.</li>
<li><strong>Migrar pela metade recria o cluster.</strong> Com só o cluster movido, o <code>plan</code> responde <code>module.eks.aws_eks_cluster.main must be replaced</code>: o <code>role_arn</code> dele aponta para a role dentro do módulo, que ainda não está no state e vira <code>(known after apply)</code>. Um <code>apply</code> nesse meio-termo <strong>destrói o cluster</strong>, mesmo com <code>-target</code>.</li>
<li><strong><code>path.module</code> muda de significado.</strong> Dentro do módulo ele aponta para <code>modules/eks/</code>. O JSON da policy do AWS Load Balancer Controller tem que ir junto, senão o <code>plan</code> falha ao ler o arquivo.</li>
<li><strong>O provider da Cloudflare não é <code>hashicorp/</code>.</strong> Um módulo que usa esse provider precisa declarar de onde ele vem, num bloco <code>required_providers</code>. Sem isso, o <code>init</code> procura um <code>hashicorp/cloudflare</code> que não existe.</li>
</ul>

<h2>Critérios de aceitação</h2>
<ul>
<li>Os diretórios <code>modules/eks/</code> e <code>modules/acm/</code> existem, cada um com <code>variables.tofu</code> e <code>outputs.tofu</code>.</li>
<li>Na raiz sobram só <code>eks.tofu</code> e <code>acm.tofu</code> com as chamadas dos módulos. Nenhum <code>eks_*.tofu</code>.</li>
<li><code>tofu fmt -check -recursive</code> não aponta arquivos para formatar, e <code>tofu validate</code> responde <code>Success</code>.</li>
<li><code>tofu state list</code> não mostra nenhum <code>aws_eks_*</code>, <code>aws_iam_*</code>, <code>helm_release</code>, <code>kubernetes_*</code> ou <code>aws_acm_*</code> na raiz: tudo está dentro de <code>module.eks</code> ou <code>module.acm</code>.</li>
<li><code>kubectl get nodes</code> mostra os nodes <code>Ready</code>.</li>
<li>O Ingress com HTTPS da 6.14 responde no navegador, com o certificado do ACM.</li>
<li>Caminho B: <code>tofu plan -var-file=dev.tfvars -target=module.eks -target=module.acm</code> responde <code>No changes. Your infrastructure matches the configuration.</code></li>
<li>Caminho B: os nodes são os <strong>mesmos</strong> de antes da migração (mesmo nome e mesma idade no <code>kubectl get nodes</code>).</li>
</ul>

<h3>Dicas</h3>
<ul>
<li>Comece pelo módulo do ACM. Ele é pequeno, tem três recursos, e ensina todo o caminho (variáveis, outputs, chamada na raiz, <code>state mv</code>) antes de você encarar os mais de vinte recursos do EKS.</li>
<li>Recursos com <code>for_each</code> (add-ons, policy attachments, records de validação) podem ser movidos de uma vez, <strong>sem</strong> a chave entre colchetes: <code>tofu state mv aws_eks_addon.main module.eks.aws_eks_addon.main</code> leva todas as instâncias.</li>
<li>Rode o <code>plan</code> <strong>antes</strong> de migrar e guarde a saída. Comparar o &quot;antes&quot; com o &quot;depois&quot; é a melhor prova de que a migração funcionou.</li>
<li>O nome do cluster aparece em vários lugares: nas tags do ALB, no IRSA, no <code>update-kubeconfig</code>. Se ele mudar, você não modularizou: você criou outro cluster.</li>
<li>A 6.14 e a pasta do desafio usam a <strong>mesma key de state</strong> no S3. Depois de migrar, opere só pela pasta nova: um <code>apply</code> na antiga tentaria recriar tudo.</li>
<li>Segredo não entra em arquivo <code>.tfvars</code>. O token da Cloudflare vai por <code>TF_VAR_cloudflare_api_token</code>. E lembre que <code>-var-file</code> tem precedência sobre <code>TF_VAR_*</code>: se o token também estiver no tfvars, é o do tfvars que vale.</li>
<li>Se algo der errado <strong>antes</strong> do <code>apply</code>, o backup desfaz tudo: <code>tofu state push -force backup-antes-da-migracao.tfstate</code>.</li>
<li><strong>Desafio extra, para quem seguiu o caminho B:</strong> refaça a migração com blocos <code>moved</code> no código, em vez de <code>tofu state mv</code>. Compare as duas abordagens: qual delas fica registrada no Git? Qual acontece na hora, e qual só acontece no próximo <code>apply</code>?</li>
</ul>
