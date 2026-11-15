<h2><strong>Objetivo</strong></h2>
<p>Transformar os seis manifestos soltos do <code>delivery-tracking</code> (aula <strong>5.22</strong>) num <strong>Helm chart</strong> e subir a aplicação no EKS com o <strong>Helm CLI</strong>, usando como banco o <strong>chart do Postgres que você criou na aula 6.09</strong>.</p>

<h2><strong>Contexto</strong></h2>
<p>Na aula 6.09 você empacotou o Postgres como chart e viu o ciclo completo de uma release: <code>install</code>, <code>upgrade</code>, <code>history</code>, <code>uninstall</code>. O <code>delivery-tracking</code> continua como no Kind, em seis arquivos com tudo fixo no YAML: porta, imagem, senha, classe do Ingress.</p>
<pre><code>k8s/delivery-tracking/          (o seu ponto de partida)
├── delivery-tracking.configmap.yaml
├── delivery-tracking.secret.yaml
├── delivery-tracking.deployment.yaml
├── delivery-tracking.service.yaml
├── delivery-tracking.ingress.yaml
└── delivery-tracking.hpa.yaml
</code></pre>
<p>Esses arquivos foram escritos para o <strong>Kind</strong>. Vários valores ali não fazem sentido no EKS, e o chart é justamente o lugar para separar o que é <strong>estrutura</strong> (template) do que é <strong>ambiente</strong> (values).</p>
<p>Na aula 6.17, quem vai instalar este chart é o <strong>OpenTofu</strong>, ligado ao RDS. Aqui o &quot;botão&quot; ainda é o seu.</p>

<h2><strong>Ponto de partida</strong></h2>
<p>Use o código da aula <strong>6.15</strong>, com o cluster, o AWS Load Balancer Controller e o certificado do ACM no ar:</p>
<p>Projeto base: <a href="https://github.com/algaworks/curso-especialista-microsservicos-nivel-11/tree/main/06.15-desafio-modularizacao-eks-acm" target="_blank" rel="noopener">06.15-desafio-modularizacao-eks-acm</a></p>
<p>Copie para dentro da pasta <code>k8s/</code> os manifestos do <code>delivery-tracking</code> da aula 5.22 e use o chart do Postgres que já está em <code>k8s/helm/postgres/</code>:</p>
<p>Manifestos: <a href="https://github.com/algaworks/curso-especialista-microsservicos-nivel-11/tree/main/05.22-metrics-server-e-hpa-autoscaling-de-pods/delivery-tracking/k8s" target="_blank" rel="noopener">05.22 · delivery-tracking/k8s</a></p>
<p><strong>Este desafio não mexe em OpenTofu.</strong> Todo o trabalho é Helm, com o CLI, como na 6.09.</p>

<h2>O que você deve implementar</h2>

<h3>1. Criar o chart <code>k8s/helm/delivery-tracking/</code></h3>
<ul>
<li><code>Chart.yaml</code>, <code>values.yaml</code> e os seis manifestos convertidos em <code>templates/</code>.</li>
<li>Todo valor que muda de ambiente para ambiente vira <strong>value</strong>: imagem, porta, recursos, credenciais do banco, host do Ingress, parâmetros do HPA.</li>
<li>A porta aparece em quatro lugares nos manifestos da 5.22. No chart, ela tem que vir de <strong>um lugar só</strong>.</li>
</ul>

<h3>2. Adaptar para o EKS</h3>
<ul>
<li><strong>Imagem:</strong> a <code>delivery-tracking:v1.0.0</code> era local (<code>kind load</code>), e o EKS não tem como baixá-la. Use a imagem pública do Docker Hub: <strong><code>algaworks/delivery-tracking:1.0.3</code></strong>. Repositório e tag viram values.</li>
<li><strong>Ingress:</strong> troque o Traefik pelo <strong>ALB</strong>, com HTTPS e o certificado do ACM da aula 6.14, no mesmo <code>group.name</code> dos Ingress que você já tem. Host: <code>delivery-tracking.dev.&lt;seu-dominio&gt;</code>.</li>
<li><strong>Kafka:</strong> não há Kafka no EKS ainda. A aplicação tem que subir sem ele.</li>
<li><strong>Senha:</strong> não pode ter padrão no <code>values.yaml</code>. Se alguém esquecer de passar, o <code>install</code> tem que falhar, e não subir com senha vazia.</li>
</ul>

<h3>3. Subir o banco com o chart da 6.09</h3>
<p>Instale o Postgres com o seu próprio chart, no namespace <code>algadelivery</code>. <strong>Não</strong> mude o chart: o que precisar mudar entra por um arquivo de override (<code>-f</code>).</p>

<h3>4. Instalar o <code>delivery-tracking</code></h3>
<p>Com o Helm CLI, no mesmo namespace, apontando para o Postgres do passo anterior.</p>

<h3>5. Provar que funcionou</h3>
<p>Não vale &quot;a release ficou <code>deployed</code>&quot;. A prova é a aplicação respondendo pelo ALB, com HTTPS:</p>
<pre><code>curl https://delivery-tracking.dev.&lt;seu-dominio&gt;/actuator/health
</code></pre>

<h3>6. Limpar</h3>
<p>Na aula 6.17 o OpenTofu vai instalar o mesmo chart, no mesmo namespace, com o mesmo nome de release. Deixe o cluster como encontrou: sem as releases, sem os PVCs e sem o namespace.</p>

<h3>Atenção aos pontos que quebram</h3>
<ul>
<li><strong>O chart do Postgres tem uma armadilha.</strong> Olhe o <code>image</code> do <code>values.yaml</code> dele antes de instalar e pergunte-se se essa imagem existe no Docker Hub. O sintoma é <code>ImagePullBackOff</code>.</li>
<li><strong>A senha tem que bater.</strong> O <code>delivery-tracking</code> conecta com a senha que o chart do Postgres gravou no <strong>primeiro boot</strong> do volume. Mudar a senha depois não muda o banco.</li>
<li><strong>O Ingress não pode se chamar <code>algadelivery</code>.</strong> No ALB, quem junta os Ingress é o <code>group.name</code>. Reusar o nome de outro Ingress apaga a regra dele, e o <code>apply</code> responde <code>configured</code> sem avisar.</li>
<li><strong>Com HPA, o Deployment não tem <code>replicas</code>.</strong> Senão, a cada <code>helm upgrade</code> o Deployment volta para o número fixo e briga com o HPA.</li>
<li><strong>Banco antes da aplicação.</strong> Sem o Postgres pronto, o Flyway falha no boot e o Pod entra em <code>CrashLoopBackOff</code>.</li>
<li><strong>O <code>helm uninstall</code> não apaga PVC.</strong> Você já viu isso na 6.09. Um volume esquecido continua cobrando, e um <code>install</code> futuro reaproveita a senha antiga.</li>
</ul>

<h2>Critérios de aceitação</h2>
<ul>
<li><code>helm lint k8s/helm/delivery-tracking</code> passa.</li>
<li><code>helm template</code> <strong>sem</strong> a senha falha com uma mensagem clara.</li>
<li>A porta do container aparece em <strong>um</strong> lugar no <code>values.yaml</code>.</li>
<li>O chart do Postgres da 6.09 foi usado <strong>sem alteração</strong>, só com override.</li>
<li><code>helm list -n algadelivery</code> mostra as releases <code>postgres</code> e <code>delivery-tracking</code>, <code>deployed</code>.</li>
<li>O Deployment renderizado <strong>não tem</strong> o campo <code>replicas</code>.</li>
<li><code>kubectl get hpa -n algadelivery</code> mostra um percentual em <code>TARGETS</code>, e não <code>&lt;unknown&gt;</code>.</li>
<li><code>GET /actuator/health</code> responde <code>{&quot;status&quot;:&quot;UP&quot;}</code> <strong>pelo ALB, com HTTPS</strong>.</li>
<li>As tabelas do Flyway existem no <code>deliverydb</code>.</li>
<li>No fim, o namespace <code>algadelivery</code> foi removido, <strong>com</strong> os PVCs.</li>
</ul>

<h3>Dicas</h3>
<ul>
<li>Abra os seis manifestos lado a lado com os templates. A estrutura é a mesma: o valor do desafio está em decidir <strong>o que vira value</strong>, não em digitar YAML.</li>
<li>Para ver o YAML que o chart gera sem instalar nada: <code>helm template &lt;release&gt; &lt;chart&gt; -f &lt;override&gt;</code>. É o mesmo comando que você usou na 6.09.</li>
<li>Para o <code>install</code> falhar sem a senha, procure a função <code>required</code> dos templates do Helm.</li>
<li>O ARN do certificado já é output do OpenTofu (<code>tofu output -raw acm_certificate_arn</code>). O <code>--set-string</code> do Helm aceita <code>$( ... )</code>, e os pontos da chave da anotação precisam de <code>\.</code>.</li>
<li>Para gerar as variáveis do ConfigMap a partir de um mapa: <code>{{ range $key, $value := .Values.config }}</code>. Use <code>| quote</code>: no ConfigMap, todo valor é string.</li>
<li>Se a aplicação ficar tentando conectar no Kafka no boot, é o <code>KafkaAdmin</code> tentando criar o tópico. A propriedade <code>spring.kafka.admin.auto-create</code> desliga isso. Na variável de ambiente, ponto vira <code>_</code>, hífen some e tudo fica maiúsculo.</li>
<li>Mudou o ConfigMap com <code>helm upgrade</code> e o Pod continua com o valor antigo? Variável de ambiente só é lida quando o container sobe. Pesquise o padrão <code>checksum/config</code> com <code>sha256sum</code> no template do Pod.</li>
<li><strong>Desafio extra, para quem quiser ir além:</strong> faça um <code>helm upgrade</code> mudando só o <code>autoscaling.minReplicas</code> e depois um <code>helm rollback</code>. Qual recurso mudou em cada revisão do <code>helm history</code>? Os Pods reiniciaram? Por quê?</li>
</ul>
