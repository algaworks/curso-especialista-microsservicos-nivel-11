<h2><strong>Objetivo</strong></h2>
<p>Instalar o <strong>Metrics Server</strong> no cluster EKS como um <strong>EKS add-on gerenciado pelo OpenTofu</strong>, no mesmo padrão dos add-ons que você já configurou nas aulas <strong>6.07</strong> e <strong>6.08</strong>, e provar que o cluster passou a ter métricas de CPU e memória, que é o pré-requisito do HPA.</p>

<h2><strong>Contexto</strong></h2>
<p>No Módulo 5 você configurou um HPA no Kind e viu que ele só funciona com o <strong>Metrics Server</strong> instalado. É ele que coleta CPU e memória dos kubelets e publica esses números na API <code>metrics.k8s.io</code>. O HPA consulta essa API a cada ~15 segundos para decidir se escala.</p>
<p>O cluster EKS que você montou até a aula 6.08 já tem quatro add-ons, todos criados pelo OpenTofu: <code>vpc-cni</code>, <code>kube-proxy</code>, <code>coredns</code> e <code>aws-ebs-csi-driver</code>. O Metrics Server <strong>não vem com o EKS</strong>. Rode isto no seu cluster:</p>
<pre><code>kubectl top nodes
</code></pre>
<pre><code>error: Metrics API not available
</code></pre>
<p>Sem ele, qualquer HPA que você subir fica com <code>TARGETS &lt;unknown&gt;/50%</code> e nunca escala. O Módulo 9 e o Módulo 11 vão precisar dessas métricas, e a hora de resolver isso é agora, junto com os outros add-ons.</p>
<p>A AWS oferece o Metrics Server como <strong>add-on da comunidade</strong> (<em>community add-on</em>): a EKS empacota, testa e entrega a versão, mas o software é do projeto <code>kubernetes-sigs</code>, não da AWS. Na prática, ele se instala do mesmo jeito que os outros add-ons.</p>

<h2><strong>Ponto de partida</strong></h2>
<p>Use o código da aula <strong>6.08</strong>, que já tem o cluster, o node group, os add-ons e o EBS CSI Driver com IRSA:</p>
<p>Projeto base: <a href="https://github.com/algaworks/curso-especialista-microsservicos-nivel-11/tree/main/06.08-configurando-ebs-csi-driver" target="_blank" rel="noopener">06.08-configurando-ebs-csi-driver</a></p>
<p>Antes de começar, abra o <code>eks_addons.tofu</code> e a variável <code>eks_addons</code> no <code>variables.tofu</code>. É deles que sai a resposta da maior parte do desafio.</p>

<h2>O que você deve implementar</h2>

<h3>1. Descobrir o add-on</h3>
<p>Encontre o <strong>nome exato</strong> do add-on e as <strong>versões compatíveis</strong> com a versão do Kubernetes do seu cluster, pelo Console ou pela AWS CLI:</p>
<pre><code>aws eks describe-addon-versions --addon-name metrics-server --kubernetes-version &lt;versao-do-cluster&gt;
</code></pre>
<p>Repare nos campos <code>owner</code> e <code>defaultVersion</code>, e compare o <code>owner</code> com o dos add-ons que você já instalou.</p>

<h3>2. Responder antes de escrever código: precisa de IRSA?</h3>
<p>O EBS CSI Driver precisou de uma role IRSA na aula 6.08. Decida se o Metrics Server também precisa e <strong>justifique pelo que ele faz</strong>. A resposta muda quantos recursos você vai criar.</p>

<h3>3. Instalar com OpenTofu</h3>
<ul>
<li>Adicione o Metrics Server ao cluster <strong>reaproveitando o que já existe</strong> no código.</li>
<li><strong>Fixe a versão</strong>, como foi feito com o <code>vpc-cni</code>.</li>
<li>Rode o <code>tofu plan -var-file=dev.tfvars</code> e confira que <strong>só</strong> o add-on novo aparece para ser criado.</li>
</ul>

<h3>4. Provar que funcionou</h3>
<p>Não vale &quot;o <code>apply</code> terminou&quot;. A prova é a API de métricas respondendo, nesta ordem:</p>
<ol>
<li>O add-on aparece como <code>ACTIVE</code> no Console e no <code>tofu state list</code>.</li>
<li>O Deployment do Metrics Server está rodando no namespace <code>kube-system</code>.</li>
<li>A <code>APIService</code> de métricas está registrada e disponível: <code>kubectl get apiservice v1beta1.metrics.k8s.io</code>.</li>
<li><code>kubectl top nodes</code> e <code>kubectl top pods -A</code> devolvem números.</li>
</ol>

<h3>5. (Opcional) Fechar o ciclo com um HPA</h3>
<ul>
<li>Suba o <code>k8s/whoami.yaml</code> e crie um HPA para ele, com alvo de <strong>50% de CPU</strong>, mínimo de 2 e máximo de 4 réplicas.</li>
<li>Confira que o <code>TARGETS</code> do <code>kubectl get hpa</code> mostra um percentual de verdade, e não <code>&lt;unknown&gt;</code>.</li>
<li>Explique: 50% <strong>de quê</strong>? Olhe o <code>resources</code> do <code>whoami.yaml</code>.</li>
</ul>

<h3>Atenção aos pontos que confundem</h3>
<ul>
<li><strong>Não precisa de um resource novo.</strong> Existe um <code>for_each</code> sobre um mapa de add-ons. Se o Metrics Server só precisa de nome e versão, ele cabe ali. Criar um <code>aws_eks_addon</code> separado funciona, mas é código duplicado.</li>
<li><strong>A versão precisa ser compatível com o Kubernetes do cluster.</strong> Uma versão que existe, mas não é compatível, faz o <code>apply</code> falhar na API da EKS, depois de o <code>plan</code> ter passado sem reclamar.</li>
<li><strong>O <code>apply</code> terminar não quer dizer que a métrica já existe.</strong> O add-on fica <code>ACTIVE</code> antes da primeira coleta, que leva mais uns 15 a 60 segundos. Um <code>kubectl top</code> logo depois do <code>apply</code> ainda pode dar erro.</li>
<li><strong>O <code>plan</code> não pode mexer nos outros add-ons.</strong> Se aparecer <code>update</code> ou <code>replace</code> no <code>vpc-cni</code>, no <code>kube-proxy</code> ou no <code>coredns</code>, alguma coisa além do Metrics Server mudou no seu código.</li>
</ul>

<h2>Critérios de aceitação</h2>
<ul>
<li><code>tofu fmt -check -recursive</code> não aponta arquivos para formatar, e <code>tofu validate</code> responde <code>Success</code>.</li>
<li>O <code>tofu plan</code> mostra <strong>só</strong> o add-on do Metrics Server sendo criado, sem alterar os outros.</li>
<li>O add-on <code>metrics-server</code> está <code>ACTIVE</code>, com a versão fixada no código.</li>
<li><code>kubectl get apiservice v1beta1.metrics.k8s.io</code> responde <code>AVAILABLE   True</code>.</li>
<li><code>kubectl top nodes</code> mostra CPU e memória de cada node.</li>
<li>A resposta da pergunta da IRSA está justificada pelo que o Metrics Server faz.</li>
<li>(Opcional) <code>kubectl get hpa</code> mostra um percentual em <code>TARGETS</code>, por exemplo <code>cpu: 2%/50%</code>.</li>
</ul>

<h3>Dicas</h3>
<ul>
<li>No Console, o caminho é <strong>EKS → seu cluster → Add-ons → Get more add-ons</strong>. Vale olhar por lá antes, mesmo que a instalação seja pelo OpenTofu.</li>
<li>A IRSA existe para um Pod chamar uma <strong>API da AWS</strong>. O EBS CSI Driver precisa dela porque cria e anexa volumes EBS. Pergunte-se para onde o Metrics Server manda requisições: para a AWS, ou só para dentro do cluster?</li>
<li>Para diagnosticar um <code>kubectl top</code> que não responde, a ordem é sempre a mesma: status do add-on → Pod em <code>kube-system</code> → <code>kubectl describe apiservice v1beta1.metrics.k8s.io</code>. A <code>APIService</code> diz o motivo quando está <code>False</code>.</li>
<li>Se o HPA continuar <code>&lt;unknown&gt;</code> com o Metrics Server funcionando, confira se o container declara <code>resources.requests.cpu</code>. Sem request, não existe base para calcular o percentual.</li>
<li><strong>Desafio extra, para quem quiser ir além:</strong> o <code>vpc-cni</code> fixa a versão, mas o <code>kube-proxy</code> e o <code>coredns</code> não. Descubra o que acontece com um add-on <strong>sem</strong> versão fixada no primeiro <code>apply</code>, quando a AWS publicar uma versão default nova e quando você atualizar a versão do Kubernetes do cluster. Qual das duas abordagens você usaria em produção, e por quê?</li>
</ul>
