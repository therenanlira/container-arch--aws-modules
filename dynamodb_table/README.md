# dynamodb_table

Provisiona uma tabela DynamoDB com streams habilitados, point-in-time recovery e autoscaling de leitura e escrita. É a tabela primária de uma Global Table — as réplicas em outras regiões vêm do módulo [`dynamodb_table_replica`](../dynamodb_table_replica).

A chave primária é fixa: `id`, do tipo string.

## Uso

```hcl
module "dynamodb" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//dynamodb_table?ref=v1"

  project_name = "container-arch"
  service_name = "app"
  environment  = "dev"

  dynamodb_values = {
    table_suffix              = "orders"
    billing_mode              = "PROVISIONED"
    point_in_time_recovery    = true
    recovery_period_in_days   = 7
    read_min                  = 1
    read_max                  = 10
    read_autoscale_threshold  = 70
    write_min                 = 1
    write_max                 = 10
    write_autoscale_threshold = 70
  }
}
```

O `stream_view_type` é `NEW_AND_OLD_IMAGES`, exigido pela replicação global.

`read_capacity`, `write_capacity` e `replica` estão em `ignore_changes`: as duas primeiras porque quem manda nelas é o autoscaling, e a terceira porque as réplicas são gerenciadas pelos workspaces das outras regiões.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto | `string` | — |
| `service_name` | Nome do serviço; compõe o nome da tabela | `string` | — |
| `environment` | Ambiente de deploy | `string` | — |
| `dynamodb_values` | Objeto com `table_suffix`, `billing_mode`, PITR e os limites de autoscaling de leitura/escrita | `object` | `null` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `arn` | ARN da tabela — é o que o módulo de réplica consome |

Os demais outputs apenas ecoam as variáveis recebidas.
