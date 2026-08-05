# ec2_instance

Provisiona uma instância EC2 simples, com security group, IAM role/instance profile com acesso via SSM Session Manager e volume root criptografado. Por padrão a instância sobe na primeira subnet privada; para um bastion, use `subnet_placement = "public"`.

## Uso

```hcl
module "bastion" {
  source = "git::https://github.com/therenanlira/container-arch--aws-modules.git//ec2_instance?ref=v1"

  project_name   = "container-arch"
  service_name   = "bastion"
  environment    = "dev"
  network_values = data.terraform_remote_state.aws_vpc.outputs

  instance_type    = "t3.small"
  subnet_placement = "public"
  key_name         = "bastion"
}
```

O key pair **não é gerenciado por este módulo** — crie-o fora do Terraform (assim ele sobrevive a um `destroy`) e passe o nome em `key_name`:

```bash
ssh-keygen -t ed25519 -f ~/.ssh/bastion -C bastion
aws ec2 import-key-pair --key-name bastion --public-key-material fileb://~/.ssh/bastion.pub
ssh -i ~/.ssh/bastion ec2-user@<public_ip>
```

Por padrão a porta 22 fica liberada para `0.0.0.0/0` (autenticação só por chave; a AL2023 já vem com password auth desabilitado). Para restringir, informe `allowed_ssh_cidrs` — com lista vazia não há ingress algum e o acesso fica só por SSM Session Manager (`aws ssm start-session --target <id>`), que depende apenas do egress e da role `AmazonSSMManagedInstanceCore`.

Instâncias em subnet privada precisam de saída para a internet (NAT) ou dos VPC endpoints de SSM para o agente conseguir se registrar.

## Inputs

| Nome | Descrição | Tipo | Default |
| --- | --- | --- | --- |
| `project_name` | Nome do projeto, usado em tags e nomes de recursos | `string` | — |
| `service_name` | Nome da instância (ex.: `bastion`) | `string` | — |
| `environment` | Ambiente de deploy | `string` | — |
| `network_values` | Output do repositório que usa o módulo [`vpc_network`](../vpc_network) (`vpc_id`, `vpc_cidr_block`, `private_subnet_ids`, `public_subnet_ids`) | `object` | — |
| `ami` | AMI da instância; se `null`, usa a última Amazon Linux 2023 (x86_64) | `string` | `null` |
| `instance_type` | Tipo de instância EC2 | `string` | `"t3.small"` |
| `subnet_placement` | Tier de subnet onde a instância sobe (`public` ou `private`); usa a primeira subnet do tier | `string` | `"private"` |
| `associate_public_ip_address` | Associa IP público; se `null`, segue o `subnet_placement` | `bool` | `null` |
| `key_name` | Nome de um key pair já existente (criado fora do Terraform) para acesso SSH | `string` | `null` |
| `volume_size` | Tamanho do volume root EBS (GB) | `string` | `"8"` |
| `volume_type` | Tipo do volume root EBS (`gp3`, etc) | `string` | `"gp3"` |
| `user_data` | Script de user data executado no boot | `string` | `null` |
| `allowed_ssh_cidrs` | CIDRs liberados na porta 22; vazio = sem ingress (só SSM) | `list(string)` | `["0.0.0.0/0"]` |
| `iam_policy_arns` | ARNs de policies gerenciadas extras para a role da instância | `list(string)` | `[]` |

## Outputs

| Nome | Descrição |
| --- | --- |
| `id` | ID da instância (usado no `--target` do SSM Session Manager) |
| `arn` | ARN da instância |
| `ami` | AMI efetivamente usada |
| `availability_zone` | AZ da instância |
| `private_ip` | IP privado |
| `public_ip` | IP público (vazio se não houver) |
| `security_group_id` | ID do security group da instância |
| `iam_role_name` | Nome da role da instância |
| `iam_role_arn` | ARN da role da instância |
| `iam_instance_profile_name` | Nome do instance profile |
