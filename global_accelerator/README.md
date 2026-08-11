# global_accelerator

Provisiona um AWS Global Accelerator e seu listener: os IPs anycast e a porta de entrada que recebem o tráfego e o distribuem entre as regiões. Quem registra cada região é o módulo [`global_accelerator_endpoint`](../global_accelerator_endpoint).

Deve ser criado **uma vez só**, no workspace da região central, já que o accelerator é um recurso global.

## Provider

A API do Global Accelerator existe apenas em `us-west-2`, independente de onde estão os endpoints. Como todos os recursos deste módulo são de GAX, o root mapeia um provider daquela região no lugar do default:

```hcl
provider "aws" {
  alias  = "gax"
  region = "us-west-2"
}

module "global_accelerator" {
  source    = "git::https://github.com/therenanlira/container-arch--aws-modules.git//global_accelerator?ref=v1"
  providers = { aws = aws.gax }

  service_name = "container-arch"
  environment  = "dev"
}
```

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `service_name` | Nome que compõe o nome do accelerator | `string` | — |
| `environment` | Ambiente de deploy | `string` | — |
| `enabled` | Se `false`, o accelerator existe mas não roteia tráfego | `bool` | `true` |
| `ip_address_type` | `IPV4` ou `DUAL_STACK` | `string` | `"IPV4"` |
| `listener_protocol` | `TCP` ou `UDP` | `string` | `"TCP"` |
| `listener_ports` | Lista de `{from_port, to_port}` aceitos pelo listener | `list(object)` | porta 80 |
| `client_affinity` | `NONE` distribui por 5-tuple, `SOURCE_IP` fixa o cliente num endpoint | `string` | `"SOURCE_IP"` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `listener_arn` | ARN do listener — é o que cada região consome para registrar seu endpoint group |
| `global_accelerator_id` | ARN do accelerator |
| `global_accelerator_dns` | DNS name do accelerator |
| `global_accelerator_ip_sets` | IPs anycast atribuídos |
| `global_accelerator_hosted_zone_id` | Zone ID para registros alias no Route 53 |

## Custo

O accelerator tem taxa fixa de ~US$ 0,025/hora (~US$ 18/mês) mesmo sem tráfego, mais o prêmio por GB transferido.
