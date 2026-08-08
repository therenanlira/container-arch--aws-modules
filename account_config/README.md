# account_config

Configurações que valem para a **conta inteira** (por região), e não para um ambiente específico. Hoje o módulo cuida da role que permite ao API Gateway escrever logs no CloudWatch.

`aws_api_gateway_account` é um recurso singleton: existe um por conta/região. Por isso ele mora aqui e não no módulo [`api_gateway`](../api_gateway) — se cada API criasse o seu, elas sobrescreveriam a configuração umas das outras. Este módulo é aplicado uma vez, pelo repositório `container-arch--aws-vpc`, que é o primeiro do ciclo.

Sem essa role, o `enable_log` do módulo `api_gateway` cria o log group mas o API Gateway não consegue gravar nada nele.

## Uso

```hcl
module "account_settings" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//account_config?ref=v1"

  api_gateway_logging = true
}
```

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `api_gateway_logging` | Cria a role `<account_id>-apigw-role` com a policy `AmazonAPIGatewayPushToCloudWatchLogs` e a associa em `aws_api_gateway_account` | `bool` | `true` |
| `common_tags` | Tags base da conta | `map(string)` | `{}` |

## Outputs

Nenhum output próprio — o módulo apenas ecoa as variáveis recebidas.
