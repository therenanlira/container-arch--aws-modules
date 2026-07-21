# container-arch--aws-modules

Módulos Terraform reutilizáveis para a arquitetura de containers na AWS (VPC, ECS, ECR, EFS), consumidos pelos repositórios `container-arch--aws-vpc`, `container-arch--aws-ecs-cluster` e `container-arch--aws-ecs-app`.

## Módulos

| Módulo | Descrição |
| --- | --- |
| [`vpc_network`](vpc_network/README.md) | VPC, subnets (públicas/privadas/dados) e VPC endpoints |
| [`ecs_cluster`](ecs_cluster/README.md) | Cluster ECS, capacity providers, ASG e Load Balancer |
| [`ecs_service`](ecs_service/README.md) | Serviço ECS, task definition, target group, autoscaling e EFS mounts |
| [`ecr_repository`](ecr_repository/README.md) | Repositório ECR (usado internamente por `ecs_service`) |
| [`efs_storage`](efs_storage/README.md) | Sistema de arquivos EFS |

## Versionamento

Releases seguem semver (`vMAJOR.MINOR.PATCH`), criadas automaticamente a cada push/merge na `main`. Por padrão o bump é de patch; inclua `#minor` ou `#major` na mensagem do commit de merge para subir a respectiva parte.

Duas tags flutuantes são mantidas a cada release, para consumo via `?ref=`:

- `v1` — sempre a última release da major (updates non-breaking)
- `v1.4` (major.minor) — só recebe patches daquela série

```hcl
source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//<módulo>?ref=v1"
```

## CI

O workflow `release.yaml` descobre os módulos automaticamente (qualquer diretório de primeiro nível com `.tf` na raiz — nada a configurar ao adicionar um módulo novo) e roda `terraform fmt -check` + `terraform validate` em cada um. Isso acontece tanto em PRs para `main` (check, sem gerar release) quanto no merge (check + release).
