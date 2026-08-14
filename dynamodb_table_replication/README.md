# dynamodb_table_replica

Cria a réplica de uma Global Table do DynamoDB na região do workspace, a partir da tabela primária criada pelo módulo [`dynamodb_table`](../dynamodb_table).

O recurso vive no state da região que replica, não no da primária — o que evita a dependência circular entre as duas regiões e faz a ordem ser sempre central → borda.

## Uso

```hcl
module "dynamodb_replica" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//dynamodb_table_replica?ref=v1"

  global_table_arn = data.terraform_remote_state.aws_ecs_app_central.outputs.dynamodb_arn
}
```

A tabela primária precisa existir antes, e continuar existindo: destruir a região central com réplicas ativas falha. No destroy, as bordas saem primeiro.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `global_table_arn` | ARN da tabela primária que será replicada | `string` | `null` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `arn` | ARN da réplica |
