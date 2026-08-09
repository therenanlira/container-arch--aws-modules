applicationName: '${APPLICATION_NAME}'
deploymentGroupName: '${APPLICATION_NAME}'
revision:
  revisionType: AppSpecContent
  AppSpecContent:
    content: |
      version: 0.0
      Resources:
        - TargetService:
            Type: AWS::ECS::Service
            Properties:
              TaskDefinition: '${TASK_DEFINITION}'
              LoadBalancerInfo:
                ContainerName: '${CONTAINER_NAME}'
                ContainerPort: '${CONTAINER_PORT}'
              CapacityProviderStrategy:
                %{ for cpp in CAPACITY_PROVIDER }
                - capacityProvider: '${cpp.capacity_provider}'
                  weight: '${cpp.weight}'

                %{ endfor ~}
