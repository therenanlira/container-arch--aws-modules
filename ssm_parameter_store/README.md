# ssm_parameter_store

Provisiona um parâmetro no SSM Parameter Store (tipo `String`). Útil para injetar configuração/segredos no `secrets` do módulo [`ecs_service`](../ecs_service).

## Uso

```hcl
module "ssm_parameter" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//ssm_parameter_store?ref=v1"

  service_name = "app"
  value        = "abc123456"
}
```

O nome do parâmetro é montado como `/<workspace>/<região>/<service_name>` (ex.: `/dev/us-east-2/app`).

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `service_name` | Nome do parâmetro (parte final do path) | `string` | — |
| `value` | Valor do parâmetro | `string` | — |

## Outputs

| Nome | Descrição |
| --- | --- |
| `arn` | ARN do parâmetro (usado em `valueFrom` do `secrets` do `ecs_service`) |
| `name` | Nome completo do parâmetro |
