# ecr_repository

Provisiona um repositório ECR (com scan on push e política de lifecycle mantendo as 10 imagens mais recentes). Normalmente consumido como módulo aninhado pelo [`ecs_service`](../ecs_service), mas pode ser usado isoladamente.

## Uso

```hcl
module "ecr_repository" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//ecr_repository?ref=v1"

  service_name = "app"
}
```

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `service_name` | Nome do serviço ECS; vira parte do nome do repositório | `string` | — |

## Outputs

| Nome | Descrição |
| --- | --- |
| `name` | Nome do repositório ECR |
| `repository_url` | URL do repositório (para `docker push`) |
