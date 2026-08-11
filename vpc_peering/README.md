# vpc_peering

Fecha um VPC peering entre duas regiões, criando **as duas pontas de uma vez**: a solicitação, o aceite e as rotas de ida e volta. Feito para o modelo hub-and-spoke, onde uma região é a central e as demais peeram com ela.

O módulo recebe dois providers — o default aponta para a região que solicita (edge) e o alias `aws.central` para a região que aceita.

## O problema que ele resolve

Peering entre states diferentes gera dependência circular: a central precisa do VPC ID da edge para solicitar, e a edge precisa do ID da conexão para aceitar. Como aqui as duas pontas ficam no **mesmo grafo**, a dependência vira linear — basta a VPC central já existir quando a edge for aplicada.

Na prática o módulo é chamado apenas do workspace da edge, e o state da central não sabe do peering. É o custo de não precisar de um terceiro state e de uma terceira pipeline.

## Uso

```hcl
provider "aws" {
  alias  = "central"
  region = local.workspace.central_region
}

module "peering" {
  count  = local.workspace.is_central ? 0 : 1
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//vpc_peering?ref=v1"

  providers = {
    aws         = aws
    aws.central = aws.central
  }

  environment = local.workspace.environment

  network_values = {
    vpc_id                  = module.vpc.vpc_id
    vpc_cidr_block          = module.vpc.cidr_block
    private_subnet_ids      = module.vpc.private_subnet_ids
    private_route_table_ids = module.vpc.private_route_table_ids
  }

  target_account_id      = local.workspace.central_account
  target_vpc_id          = data.terraform_remote_state.aws_vpc_central[0].outputs.vpc_id
  target_region          = local.workspace.central_region
  target_route_table_ids = data.terraform_remote_state.aws_vpc_central[0].outputs.private_route_table_ids
  target_cidr_block      = data.terraform_remote_state.aws_vpc_central[0].outputs.vpc_cidr_block
}
```

O `count` evita que a região central tente peerar consigo mesma, e o `data.terraform_remote_state` lê o state da central — lembrando que o `region` daquele data source é a **região do bucket**, não a do ambiente.

## Ordem de apply e destroy

A central precisa existir antes da edge, e sair depois dela: uma VPC com peering ativo não é destruída (`DependencyViolation`). Nos workflows isso é garantido com `max-parallel: 1` e a matriz na ordem certa — central primeiro no apply, edge primeiro no destroy.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `environment` | Ambiente de deploy; compõe o `Name` do peering | `string` | — |
| `network_values` | Dados da VPC que solicita (`vpc_id`, `vpc_cidr_block`, `private_subnet_ids`, `private_route_table_ids`) | `object` | — |
| `target_account_id` | Conta da VPC que aceita | `string` | — |
| `target_vpc_id` | VPC que aceita o peering | `string` | — |
| `target_region` | Região da VPC que aceita | `string` | — |
| `target_route_table_ids` | Route tables da VPC que aceita, onde entra a rota de volta | `map(string)` | — |
| `target_cidr_block` | CIDR da VPC que aceita | `string` | — |

Os CIDRs das duas VPCs não podem se sobrepor — no projeto, `10.0.0.0/16` na central e `10.1.0.0/16` na edge.

## Outputs

Nenhum output próprio.
