param containerAppsEnvName string
param location string

param minReplicas int = 0

resource cappsEnv 'Microsoft.App/managedEnvironments@2022-06-01-preview' existing = {
  name: containerAppsEnvName
}

resource ui 'Microsoft.App/containerApps@2022-06-01-preview' = {
  name: 'ui'
  location: location
  properties: {
    managedEnvironmentId: cappsEnv.id
    template: {
      containers: [
        {
          name: 'ui'
          image: 'ghcr.io/azure/reddog-retail-demo/reddog-retail-ui:latest'
          env: [
            {
              name: 'VUE_APP_IS_CORP'
              value: 'false'
            }
            {
              name: 'VUE_APP_STORE_ID'
              value: 'Redmond'
            }
            {
              name: 'VUE_APP_SITE_TYPE'
              value: 'Pharmacy'
            }
            {
              name: 'VUE_APP_SITE_TITLE'
              value: 'Red Dog Bodega :: Market fresh food, pharmaceuticals, and fireworks!'
            }
            {
              name: 'VUE_APP_MAKELINE_BASE_URL'
              value: 'http://localhost:3500/v1.0/invoke/make-line-service/method'
            }
            {
              name: 'VUE_APP_ACCOUNTING_BASE_URL'  
              value: 'http://localhost:3500/v1.0/invoke/accounting-service/method'
            }
          ]
        }
      ]
      scale: {
        minReplicas: minReplicas
      }
    }
    configuration: {
      dapr: {
        enabled: true
        appId: 'ui'
        appProtocol: 'http'
      }
      ingress: {
        external: false
        targetPort: 8080
      }
    }
  }
}
