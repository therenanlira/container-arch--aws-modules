# ecs_cluster

Provisiona um cluster ECS com capacity providers (ON_DEMAND/SPOT/FARGATE), Auto Scaling Group + Launch Template, e um Application/Network Load Balancer compartilhado pelos serviços.

## Uso

```hcl
module "ecs_cluster" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//ecs_cluster?ref=v1"

  project_name   = "container-arch"
  environment    = "dev"
  network_values = data.terraform_remote_state.aws_vpc.outputs

  capacity_provider_strategies = ["FARGATE", "FARGATE_SPOT"]
  ecs_autoscaling = {
    FARGATE = {
      minimum = "1"
      maximum = "3"
      desired = "1"
    }
    FARGATE_SPOT = {
      minimum = "1"
      maximum = "3"
      desired = "1"
    }
  }
  ecs_ami           = "ami-04ea4e8270c27626c"
  ecs_instance_type = "t3.small"
  ecs_volume_size   = "50"
  ecs_volume_type   = "gp3"

  load_balancer_internal = false
  load_balancer_type     = "application"

  user_data_template = "${path.module}/templates/user-data.tpl"
}
```

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto, usado em tags e nomes de recursos | `string` | — |
| `environment` | Ambiente de deploy | `string` | — |
| `network_values` | Output do módulo [`network`](../network) (`vpc_id`, `vpc_cidr_block`, `private_subnet_ids`, `public_subnet_ids`, `data_subnet_ids`) | `object` | — |
| `capacity_provider_strategies` | Lista com uma ou mais de `ON_DEMAND`, `SPOT`, `FARGATE`, `FARGATE_SPOT` | `list(string)` | `["ON_DEMAND", "SPOT"]` |
| `ecs_autoscaling` | Map por capacity provider com `minimum`/`maximum`/`desired` | `map(object)` | — |
| `ecs_ami` | AMI das instâncias ECS (apenas para providers EC2) | `string` | — |
| `ecs_instance_type` | Tipo de instância EC2 | `string` | — |
| `ecs_volume_size` | Tamanho do volume EBS (GB) | `string` | — |
| `ecs_volume_type` | Tipo do volume EBS (`gp3`, etc) | `string` | — |
| `load_balancer_internal` | Se `true`, o LB é interno; se `false`, internet-facing | `bool` | — |
| `load_balancer_type` | Tipo do LB (`application`, `network`) | `string` | — |
| `user_data_template` | Caminho do template de user data das instâncias EC2 | `string` | — |

## Outputs

| Nome | Descrição |
| --- | --- |
| `ecs_cluster_name` | Nome do cluster ECS |
| `lb_arn` | ARN do Load Balancer |
| `lb_dns_name` | DNS name do Load Balancer |
| `lb_listener_arn` | ARN do listener do Load Balancer |
