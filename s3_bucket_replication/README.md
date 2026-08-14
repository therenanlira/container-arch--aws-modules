# s3_bucket_replication

Configura a replicação de um bucket S3 para os buckets de mesmo nome em outras regiões: a role de replicação, sua policy e a `aws_s3_bucket_replication_configuration` com uma regra por destino. Os buckets em si vêm do módulo [`s3_bucket`](../s3_bucket).

## Uso

Um módulo por **direção**. O workspace de borda gerencia as duas, usando um provider aliased para a região central — assim as duas configurações nascem quando os dois buckets já existem, sem dependência circular e sem passo extra.

O `providers` não é opcional na direção que configura o bucket da outra região: o `PutBucketReplication` precisa ser enviado para a região do bucket de origem, senão a AWS responde `PermanentRedirect`.

```hcl
module "replication_edge_to_central" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//s3_bucket_replication?ref=v1"

  project_name = local.workspace.project_name
  service_name = local.workspace.service_name
  environment  = local.workspace.environment

  source_bucket = {
    bucket = module.sales_offload_datalake.bucket
    region = module.sales_offload_datalake.region
  }

  destination_regions = [local.workspace.central_region]
}

module "replication_central_to_edge" {
  source    = "git::https://github.com/therenanlira/container-arch--aws-modules.git//s3_bucket_replication?ref=v1"
  providers = { aws = aws.central }

  project_name = local.workspace.project_name
  service_name = local.workspace.service_name
  environment  = local.workspace.environment

  source_bucket       = data.terraform_remote_state.central[0].outputs.sales_offload_datalake
  destination_regions = [local.workspace.aws_region]
}
```

## Nomes

O bucket de origem é recebido pronto, como um objeto `{bucket, region}`, porque quem chama o módulo já o tem em mãos — do próprio `s3_bucket` ou do state da outra região. A região vem junto do nome de propósito: é ela que nomeia a role e evita que origem e região divirjam.

Os destinos são derivados de `environment` + `destination_regions`, seguindo o mesmo padrão de nome do módulo `s3_bucket`:

```
<account_id>-<environment>-<region>--<project_name>--<service_name>
```

Como o nome é determinístico, o destino não precisa ser lido de state nenhum.

## Três ou mais regiões

Replicação no S3 **não é transitiva**: um objeto que chegou em B por replicação não é repassado para C. Cada bucket precisa de uma regra por destino, e é por isso que `destination_regions` é uma lista.

Só que uma `aws_s3_bucket_replication_configuration` é única por bucket e substitui a configuração inteira. Com três regiões, se cada borda gerenciasse a configuração do bucket central, um apply apagaria a regra do outro. Nesse cenário a configuração do bucket central precisa ser aplicada por um único lugar, que rode depois de todos os buckets existirem — um repositório próprio de replicação, por exemplo.

Com duas regiões, o desenho do exemplo acima resolve sem nada disso.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` / `service_name` / `environment` | Compõem o nome dos buckets de destino e da role | `string` | — |
| `source_bucket` | Objeto `{bucket, region}` do bucket que recebe a configuração | `object` | — |
| `destination_regions` | Regiões de destino; cada uma vira uma regra | `list(string)` | — |
| `replica_modification_sync` | Replica mudanças de metadados feitas na réplica | `bool` | `true` |
| `delete_marker_replication` | Replica delete markers | `bool` | `true` |
| `storage_class` | Storage class dos objetos replicados | `string` | `"STANDARD"` |

Os buckets de origem e destino precisam ter versionamento habilitado — o `s3_bucket` já liga por padrão.

## Outputs

| Nome | Descrição |
| --- | --- |
| `destination_buckets` | Map de região para nome do bucket de destino |
| `role_arn` | ARN da role de replicação |
| `source_region` | Região do bucket de origem |
