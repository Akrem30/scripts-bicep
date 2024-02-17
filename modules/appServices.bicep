
param location string  
@allowed(['F1','B1','S1'])
param sku string 
param webAppName string

resource servicePlan 'Microsoft.Web/serverfarms@2023-01-01' =  {
  location: location
  name: 'sp-${webAppName}'
  sku:{
    name: sku
  }
  tags: {
    Application: webAppName    
  }
}

resource applicationWeb 'Microsoft.Web/sites@2023-01-01' =  {
  location:location
  name:'webapp-${webAppName}-${uniqueString(resourceGroup().id)}'
  properties:{
    serverFarmId:servicePlan.id 
  }
  tags: {
    Application: webAppName   
  }  
}
resource stagingSlot 'Microsoft.Web/sites/slots@2023-01-01' =   if(sku=='S1') {
  location:location
  parent:applicationWeb
  name:'staging'
  properties:{
    serverFarmId:servicePlan.id
    cloningInfo: {
      sourceWebAppId: applicationWeb.id
    }
    siteConfig: {
      appSettings: [
        {
          name: 'ASPNETCORE_ENVIRONMENT'
          value: 'Development'
        }
      ]
      autoSwapSlotName:'production'
    }    
  }
  tags: {
    Application: applicationWeb.name    
  }
}

resource autoscaleSetting 'Microsoft.Insights/autoscalesettings@2022-10-01' =  if(sku=='S1') {
  name: '${applicationWeb.name}-autoscale'
  location: location
  tags: {
    Application: applicationWeb.name
  }
  properties: {
    targetResourceUri: servicePlan.id
    enabled: true
    profiles: [
      {
        name: 'Default'
        capacity: {
          minimum: '1'
          maximum: '10'
          default: '1'
        }
        rules: [
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: servicePlan.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'GreaterThan'
              threshold: 80
            }
            scaleAction: {
              direction: 'Increase'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
          {
            metricTrigger: {
              metricName: 'CpuPercentage'
              metricResourceUri: servicePlan.id
              timeGrain: 'PT1M'
              statistic: 'Average'
              timeWindow: 'PT5M'
              timeAggregation: 'Average'
              operator: 'LessThan'
              threshold: 45
            }
            scaleAction: {
              direction: 'Decrease'
              type: 'ChangeCount'
              value: '1'
              cooldown: 'PT5M'
            }
          }
        ]
      }
    ]
  }
}
