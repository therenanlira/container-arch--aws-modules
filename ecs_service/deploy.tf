# Deploy - ECS

resource "null_resource" "deploy_ecs" {
  count = strcontains(var.deployment_controller, "ECS") ? 1 : 0

  provisioner "local-exec" {
    command = "aws ecs update-service --cluster ${var.cluster_name} --service ${aws_ecs_service.main.name} --task-definition ${aws_ecs_task_definition.main.arn}"
    environment = {
      AWS_REGION = data.aws_region.current.region
    }
  }

  triggers = {
    task_definition = aws_ecs_task_definition.main.revision
  }

  depends_on = [
    aws_ecs_service.main,
    aws_ecs_task_definition.main
  ]
}

# Deploy - Code Deploy

resource "local_file" "appspec" {
  count = strcontains(var.deployment_controller, "CODE_DEPLOY") ? 1 : 0

  filename = "${path.module}/${aws_codedeploy_app.main[count.index].name}.yaml"

  content = templatefile("${path.module}/assets/appspec.yaml.tpl", {
    APPLICATION_NAME  = aws_codedeploy_app.main[0].name
    TASK_DEFINITION   = aws_ecs_task_definition.main.arn
    CONTAINER_NAME    = var.service_name
    CONTAINER_PORT    = var.service_port
    CAPACITY_PROVIDER = var.service_launch_type
  })
}

resource "null_resource" "deploy_codedeploy" {
  count = strcontains(var.deployment_controller, "CODE_DEPLOY") ? 1 : 0

  provisioner "local-exec" {
    command = "aws deploy create-deployment --cli-input-yaml file://${local_file.appspec[count.index].filename}"
    environment = {
      AWS_REGION = data.aws_region.current.region
    }
  }

  triggers = {
    task_definition = aws_ecs_task_definition.main.revision
  }

  depends_on = [
    aws_ecs_service.main,
    aws_ecs_task_definition.main,
    local_file.appspec
  ]
}

