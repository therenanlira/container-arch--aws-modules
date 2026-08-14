# sns_topic

Provisiona um tópico SNS e, opcionalmente, a subscription de uma fila SQS nele. A fila pode estar em **outra região** — é o padrão usado para as regiões de borda publicarem na fila da região central.

## Uso

```hcl
module "sns_sales" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//sns_topic?ref=v1"

  project_name = "container-arch"
  service_name = "app"
  environment  = "dev"

  topic_suffix = "sales"

  queue_arn = (local.workspace.is_central ?
    one(module.sqs_sales[*].arn) :
    one(data.terraform_remote_state.aws_ecs_app_central[*].outputs.sqs_sales_arn)
  )
}
```

Na região central o ARN vem do próprio módulo [`sqs_queue`](../sqs_queue); nas demais, do state da central.

O `topic_suffix` precisa ser igual ao `queue_suffix` da fila de destino: a resource policy da fila autoriza os publishers pelo **nome** do tópico.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto | `string` | `null` |
| `service_name` | Nome do serviço; compõe o nome do tópico | `string` | `null` |
| `environment` | Ambiente de deploy | `string` | `null` |
| `topic_suffix` | Sufixo do nome do tópico; deve casar com o `queue_suffix` da fila | `string` | `"sns"` |
| `queue_arn` | ARN da fila inscrita no tópico, de qualquer região | `string` | `null` |
| `create_subscription` | Cria a subscription da fila no tópico | `bool` | `true` |
| `raw_message_delivery` | Entrega a mensagem sem o envelope do SNS | `bool` | `true` |

O `create_subscription` é uma flag em vez de um teste sobre `queue_arn` porque o ARN costuma ser conhecido só no apply, e `count` não aceita valor computado.

## Outputs

| Nome | Descrição |
| --- | --- |
| `arn` | ARN do tópico |
| `name` | Nome do tópico |
