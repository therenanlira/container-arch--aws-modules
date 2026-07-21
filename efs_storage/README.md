# efs_storage

Provisiona um sistema de arquivos EFS para ser montado por serviços ECS (via `efs_volumes` no módulo [`ecs_service`](../ecs_service)).

## Uso

```hcl
module "efs" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//efs_storage?ref=v1"

  service_name   = "app"
  network_values = data.terraform_remote_state.aws_vpc.outputs
}
```

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `service_name` | Nome do serviço ECS; vira parte do nome do EFS | `string` | — |
| `network_values` | Output do módulo [`network`](../network) (`vpc_id`, `vpc_cidr_block`, `private_subnet_ids`, `public_subnet_ids`, `data_subnet_ids`) | `object` | — |
| `performance_mode` | Modo de performance do EFS | `string` | `"generalPurpose"` |
| `throughput_mode` | Modo de throughput do EFS | `string` | `"bursting"` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `id` | ID do sistema de arquivos (usado em `file_system_id` do `efs_volumes`) |
| `arn` | ARN do sistema de arquivos |
| `name` | Nome do sistema de arquivos |
