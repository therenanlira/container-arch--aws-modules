# global_accelerator_endpoint

Registra os endpoints de **uma região** no listener criado pelo módulo [`global_accelerator`](../global_accelerator). Cada região chama este módulo a partir do seu próprio workspace, apontando para o ALB local.

O endpoint do Global Accelerator é um ALB, NLB, Elastic IP ou instância EC2 — nunca um serviço ECS. Por isso ele vive no repositório que é dono do load balancer.

## Uso

```hcl
module "global_accelerator_endpoint" {
  source    = "git::https://github.com/therenanlira/container-arch--aws-modules.git//global_accelerator_endpoint?ref=v1"
  providers = { aws = aws.gax }

  listener_arn          = data.terraform_remote_state.aws_ecs_cluster_central.outputs.gax_listener_arn
  endpoint_group_region = local.workspace.aws_region

  endpoints = [
    {
      endpoint_id = module.ecs_cluster.lb_arn
    }
  ]

  health_check_path = "/healthcheck"
}
```

No workspace central o `listener_arn` vem direto do módulo `global_accelerator`; nos demais, do state da central.

O provider precisa ser o de `us-west-2` — veja a explicação no [`global_accelerator`](../global_accelerator/README.md#provider).

## Distribuição de tráfego

Dois controles diferentes, que costumam ser confundidos:

- **`weight`**, por endpoint, divide o tráfego **dentro** da região quando há mais de um ALB no grupo.
- **`traffic_dial_percentage`**, do grupo, define quanto do tráfego daquela região é aceito. Baixar para `0` drena a região sem remover nada — é o botão de failover manual.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `listener_arn` | Listener do accelerator ao qual o grupo pertence | `string` | — |
| `endpoint_group_region` | Região dos endpoints do grupo | `string` | — |
| `endpoints` | Lista de `{endpoint_id, weight, client_ip_preservation_enabled}` | `list(object)` | — |
| `traffic_dial_percentage` | Percentual de tráfego aceito pela região (0 a 100) | `number` | `100` |
| `health_check_protocol` | `TCP`, `HTTP` ou `HTTPS` | `string` | `"HTTP"` |
| `health_check_path` | Path do health check (ignorado quando o protocolo é TCP) | `string` | `"/"` |
| `health_check_port` | Porta do health check; `null` usa a porta do endpoint | `number` | `null` |
| `health_check_interval_seconds` | Intervalo entre checks (10 ou 30) | `number` | `30` |
| `threshold_count` | Checks consecutivos para mudar o estado do endpoint | `number` | `3` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `arn` | ARN do endpoint group |
