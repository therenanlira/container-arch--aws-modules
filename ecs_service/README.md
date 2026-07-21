# ecs_service

Provisiona um serviço ECS completo: repositório ECR ([`ecr_repository`](../ecr_repository) aninhado), task definition, target group + listener rule no ALB, security group, IAM roles, autoscaling e log group.

A imagem do container **não** é definida por uma variável explícita: o módulo resolve a tag automaticamente a partir da imagem mais recente (não-`latest`) presente no ECR (`scripts/check_ecr_latest_tag.sh`). Por isso o pipeline deve dar `push` da imagem **antes** do `terraform apply` — veja o [README do repo `app`](../../../container-arch--aws-ecs-app/README.md).

## Uso

```hcl
module "ecs_service" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//ecs_service?ref=v1"

  cluster_name   = data.terraform_remote_state.aws_ecs_cluster.outputs.ecs_cluster_name
  project_name   = "container-arch"
  network_values = data.terraform_remote_state.aws_vpc.outputs

  service_name = "app"
  service_port = 8080
  service_cpu  = 256
  service_mem  = 512

  service_healthcheck = {
    path    = "/healthcheck"
    matcher = "200-399"
  }
  service_launch_type = [
    { capacity_provider = "FARGATE_SPOT", weight = 100 }
  ]
  service_task_count = 1

  service_hosts    = ["app.example.com"]
  service_listener = data.terraform_remote_state.aws_ecs_cluster.outputs.lb_listener_arn
  alb_arn          = data.terraform_remote_state.aws_ecs_cluster.outputs.lb_arn

  scale_type = "cpu"
  task_min   = 1
  task_max   = 3

  capabilities          = ["EC2"]
  environment_variables = [{ name = "FOO", value = "BAR" }]

  efs_volumes = [
    {
      volume_name      = module.efs.name
      file_system_id   = module.efs.id
      file_system_root = "/"
      mount_point      = "/mnt/efs"
      read_only        = false
    }
  ]
}
```

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `network_values` | Output do módulo [`network`](../network) (`vpc_id`, `private_subnet_ids`) | `object` | — |
| `project_name` | Nome do projeto | `string` | — |
| `cluster_name` | Nome/ARN do cluster ECS ([`ecs_cluster`](../ecs_cluster)) | `string` | — |
| `service_name` | Nome do serviço, container e repositório ECR | `string` | — |
| `service_port` | Porta em que o container escuta | `number` | — |
| `service_cpu` | CPU units reservadas | `number` | — |
| `service_mem` | Memória (MiB) reservada | `number` | — |
| `service_healthcheck` | Map com os campos do health check do target group | `map(string)` | — |
| `service_launch_type` | Lista de `{capacity_provider, weight}` | `list(object)` | `FARGATE_SPOT` 100% |
| `service_task_count` | Quantidade inicial de tasks | `number` | — |
| `service_hosts` | Hosts usados na listener rule do ALB | `list(string)` | — |
| `service_listener` | ARN do listener do ALB | `string` | — |
| `alb_arn` | ARN do ALB (necessário para autoscaling por requests) | `string` | `null` |
| `scale_type` | `cpu`, `cpu-tracking` ou `requests-tracking` | `string` | `null` |
| `scale_tracking_cpu` | Alvo de CPU % para tracking scaling | `number` | `80` |
| `scale_tracking_requests` | Alvo de requests para tracking scaling | `number` | `0` |
| `task_min` / `task_max` | Limites de tasks no autoscaling | `number` | `3` / `10` |
| `scale_out_cpu` / `scale_in_cpu` | Configuração do step scaling por CPU (threshold, adjustment, etc) | `object` | ver `_variables.tf` |
| `capabilities` | Deve conter `"EC2"` | `list(string)` | — |
| `environment_variables` | Lista de `{name, value}` do container | `list(map(string))` | — |
| `efs_volumes` | Lista de volumes EFS a montar (`volume_name`, `file_system_id`, `file_system_root`, `mount_point`, `read_only`) | `list(object)` | `[]` |

## Outputs

Nenhum output próprio — o módulo apenas ecoa as variáveis recebidas.
