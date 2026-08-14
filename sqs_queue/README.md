# sqs_queue

Provisiona uma fila SQS com dead letter queue, redrive policy, autoscaling-friendly long polling e duas IAM policies prontas (uma de envio, outra de consumo) para anexar às roles das tasks.

A resource policy da fila autoriza tópicos SNS a publicarem nela — inclusive de **outras regiões**.

## Uso

```hcl
module "sqs_sales" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//sqs_queue?ref=v1"

  project_name = "container-arch"
  service_name = "app"
  environment  = "dev"

  publisher_regions = [for ws in var.workspaces : ws.aws_region]

  processing_config = {
    queue_suffix                  = "sales"
    delay_seconds                 = 0
    max_message_size              = 262144
    message_retention_seconds     = 86400
    receive_wait_time_seconds     = 10
    visibility_timeout_seconds    = 60
    dlq_redrive_max_receive_count = 4
  }
}
```

## Publicação entre regiões

Um ARN é determinístico — `arn:aws:sns:<região>:<conta>:<nome>` — então a policy da fila pode autorizar tópicos que **ainda não existem**, sem ler state de lugar nenhum e sem dependência circular. É isso que `publisher_regions` faz: para cada região da lista, monta o ARN do tópico de mesmo nome e o coloca na condition.

```json
"Condition": {
  "ArnEquals":    { "aws:SourceArn": ["arn:aws:sns:us-east-1:...:dev--app--sales", "..."] },
  "StringEquals": { "aws:SourceAccount": "150100906110" }
}
```

Lista vazia autoriza apenas a região da própria fila. Adicionar uma região é adicionar uma entrada — nenhuma ordem de apply é imposta.

O nome do tópico é montado com o mesmo padrão do módulo [`sns_topic`](../sns_topic), então o `topic_suffix` de lá precisa ser igual ao `queue_suffix` daqui.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto | `string` | `null` |
| `service_name` | Nome do serviço; compõe o nome da fila | `string` | `null` |
| `environment` | Ambiente de deploy | `string` | `null` |
| `processing_config` | Objeto com `queue_suffix`, delay, tamanho e retenção de mensagem, long polling, visibility timeout e o `maxReceiveCount` da DLQ | `object` | — |
| `publisher_regions` | Regiões cujos tópicos SNS podem publicar na fila; vazio = só a região da fila | `list(string)` | `[]` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `arn` | ARN da fila |
| `id` | URL da fila |
| `dlq_arn` | ARN da dead letter queue |
| `send_policy_arn` | IAM policy de envio, para anexar em quem produz |
| `receive_policy_arn` | IAM policy de consumo, para anexar em quem processa |
