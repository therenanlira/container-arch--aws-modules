# api_gateway

Provisiona um API Gateway REST (regional) a partir de uma especificação OpenAPI: REST API, deployment, stage nomeado com o workspace, throttling, log group opcional, API keys com usage plan e, opcionalmente, domínio customizado.

O roteamento até os serviços ECS é definido **dentro do OpenAPI**, na extensão `x-amazon-apigateway-integration`, usando o VPC Link criado pelo módulo [`ecs_cluster`](../ecs_cluster) (output `api_gateway_id`).

## Uso

```hcl
module "api_gateway" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//api_gateway?ref=v1"

  project_name = "container-arch"
  service_name = "app"

  body_file = templatefile("${path.module}/assets/openapi.json.tftpl", {
    environment = terraform.workspace
    vpclink_id  = data.terraform_remote_state.aws_ecs_cluster.outputs.api_gateway_id
  })

  api_key_names = ["Renan Lira"]
}
```

O `body_file` é a especificação **já renderizada** (string). Usar `templatefile()` em vez de `file()` permite injetar valores por ambiente — o ID do VPC Link, o domínio interno, o nome do stage. Dentro do template, qualquer `$` literal que não seja uma variável do Terraform (VTL do API Gateway, `${stageVariables.x}`) precisa ser escapado como `$$`.

O deployment é recriado sempre que o corpo muda, via `sha256` do body no `triggers`.

## Logging

Com `enable_log = true` (default) o módulo cria o log group `<workspace>/<project_name>/<service_name>` com retenção de 1 dia e liga `access_log_settings` no stage, além de `INFO` + métricas + data trace no `method_settings`.

O API Gateway só consegue escrever no CloudWatch se a **conta** tiver uma role de logging configurada — isso é feito uma vez por conta/região pelo módulo [`account_config`](../account_config).

## Domínio customizado

`aws_api_gateway_domain_name` e `aws_api_gateway_base_path_mapping` só são criados quando `dns_name` vem acompanhado de `certificate_arn` (domínio) e `base_mapping` (mapping). Uma validation garante que `route53_zone_id`, `certificate_arn` ou `base_mapping` não sejam passados sem `dns_name`.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto, usado no nome da API e no path do log group | `string` | — |
| `environment` | Ambiente de deploy; compõe o nome dos recursos | `string` | — |
| `service_name` | Nome do serviço; compõe o path do log group | `string` | — |
| `body_file` | Especificação OpenAPI já renderizada (string) | `string` | — |
| `api_key_names` | Nomes das API keys; cada uma ganha um usage plan (10 burst, 1 req/s, 100k/mês) | `list(string)` | `[]` |
| `enable_log` | Cria o log group e liga access log, métricas e data trace | `bool` | `true` |
| `dns_name` | Nome DNS do domínio customizado | `string` | `null` |
| `route53_zone_id` | Zone ID no Route 53 | `string` | `null` |
| `certificate_arn` | ARN do certificado ACM regional do domínio | `string` | `null` |
| `base_mapping` | Base path do mapping (ex.: `v1`) | `string` | `null` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `invoke_url` | URL do stage, já com o path do ambiente (ex.: `https://abc123.execute-api.us-east-2.amazonaws.com/dev`) |

Os demais outputs apenas ecoam as variáveis recebidas.
