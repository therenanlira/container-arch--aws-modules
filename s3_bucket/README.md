# s3_bucket

Provisiona um bucket S3 privado, com versionamento habilitado e quatro IAM policies separadas por operação (put, get, delete, list) para anexar às roles que consomem o bucket.

O versionamento é ligado por padrão porque é pré-requisito da replicação entre regiões — veja [`s3_bucket_replication`](../s3_bucket_replication).

## Uso

```hcl
module "sales_offload_datalake" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//s3_bucket?ref=v1"

  environment  = local.workspace.environment
  project_name = local.workspace.project_name
  service_name = local.workspace.service_name
}
```

## Nome do bucket

O namespace do S3 é global, então o nome combina o ID da conta com o workspace:

```
<account_id>-<workspace>--<project_name>--<service_name>
```

Ex.: `150100906110-dev-us-east-1--container-arch--app`.

Isso torna o nome **determinístico**: qualquer workspace consegue montar o nome do bucket de outra região sem ler state, o que é o que permite configurar replicação sem dependência circular.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto | `string` | — |
| `service_name` | Nome do serviço | `string` | — |
| `environment` | Ambiente de deploy | `string` | — |

## Outputs

| Nome | Descrição |
| --- | --- |
| `bucket` | Nome do bucket |
| `region` | Região do bucket; junto com `bucket` forma o `source_bucket` do módulo de replicação |
| `put_object_policy_arn` / `get_object_policy_arn` | IAM policies de escrita e leitura de objetos |
| `delete_object_policy_arn` / `list_object_policy_arn` | IAM policies de remoção de objetos e listagem do bucket |

Os demais outputs apenas ecoam as variáveis recebidas.
