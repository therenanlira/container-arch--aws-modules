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
  secrets = [
    {
      name      = "DB_PASS"
      valueFrom = module.ssm_parameter.arn
    }
  ]

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
| `network_values` | Output do repositório que usa o módulo [`vpc_network`](../vpc_network) (`vpc_id`, `private_subnet_ids`) | `object` | — |
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
| `environment_variables` | Lista de `{name, value}` do container | `list(object)` | `[]` |
| `secrets` | Lista de `{name, valueFrom}` — `valueFrom` é o ARN de um parâmetro/segredo (ex.: output `arn` de [`ssm_parameter_store`](../ssm_parameter_store) ou [`ssm_secrets_manager`](../ssm_secrets_manager)) | `list(object)` | `[]` |
| `efs_volumes` | Lista de volumes EFS a montar (`volume_name`, `file_system_id`, `file_system_root`, `mount_point`, `read_only`) | `list(object)` | `[]` |
| `deployment_controller` | `ECS` (nativo) ou `CODE_DEPLOY` | `string` | `"ECS"` |
| `ecs_deployment_type` | Estratégia nativa do ECS: `ROLLING` ou `BLUE_GREEN` | `string` | `"ROLLING"` |
| `ecs_bake_time_in_minutes` | Tempo que blue e green convivem após o desvio do tráfego, antes do ECS matar o blue | `number` | `5` |

## Deployment

O `deployment_controller` escolhe **quem** conduz o rollout, e o `ecs_deployment_type` escolhe **como**, quando quem conduz é o próprio ECS:

| Configuração | O que acontece |
| --- | --- |
| `ECS` + `ROLLING` (default) | Substitui as tasks no lugar, com `deployment_circuit_breaker` e rollback automático |
| `ECS` + `BLUE_GREEN` | Sobe uma revisão nova inteira (green), desvia o tráfego, espera o bake time e só então mata a antiga (blue) |
| `CODE_DEPLOY` | Blue/green pelo CodeDeploy, com os target groups `blue`/`green` e o deployment group |

### Blue/green nativo

Lançado pela AWS em julho/2025, resolve o mesmo problema do CodeDeploy sem serviço extra, sem AppSpec e — diferente do CodeDeploy — **funciona com Service Connect**. A estratégia é um atributo do próprio serviço:

```hcl
deployment_controller = "ECS"
ecs_deployment_type   = "BLUE_GREEN"
```

Com `enable_lb = true`, o módulo cria automaticamente o que o ECS precisa para desviar o tráfego:

- um **target group alternativo** (`-a-tg`), onde a revisão green é registrada;
- uma **role de infraestrutura** com a policy `AmazonECSInfrastructureRolePolicyForLoadBalancers`, que autoriza o ECS a reescrever a regra do listener;
- o bloco `advanced_configuration` no serviço, ligando target group primário, alternativo e a listener rule de produção.

Com `enable_lb = false` (serviços que só conversam por Service Connect), nada disso é necessário: o ECS faz o desvio no proxy do Service Connect.

Durante o deploy o ECS roda as duas revisões ao mesmo tempo, então o cluster precisa de capacidade para o dobro de tasks daquele serviço. O rollback dentro da janela de bake é imediato — é só o tráfego voltar para o blue, que ainda está de pé.

## Outputs

| Nome | Descrição |
| --- | --- |
| `target_group_arn` | ARN do target group do serviço (`null` quando `enable_lb = false`) |

Os demais outputs apenas ecoam as variáveis recebidas.
