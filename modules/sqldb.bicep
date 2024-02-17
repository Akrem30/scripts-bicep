param location string 
param dbUser string
@secure()
@minLength(10)
@maxLength(20)
param dbPassword string
@allowed(['Standard','Basic'])
param skuDb array
param namesDbs array
param nameServer string

resource sqlServer 'Microsoft.Sql/servers@2021-11-01' = {
  location: location
  name: 'srv-${nameServer}-${uniqueString(resourceGroup().id)}'
  properties: {
    administratorLogin: dbUser
    administratorLoginPassword: dbPassword
    version: '12.0'
  }
}

resource sqlFirewallRule 'Microsoft.Sql/servers/firewallRules@2023-05-01-preview' = {
  name: 'AllowAll'
  parent: sqlServer
  properties: {
    startIpAddress: '0.0.0.0'
    endIpAddress: '255.255.255.255'
  }
}

resource sqlDatabase 'Microsoft.Sql/servers/databases@2021-11-01' =  [for i in range(0, length(namesDbs)): {
  location: location
  name: 'db-${namesDbs[i]}'
  parent: sqlServer
  sku: {
    name: skuDb[i]
    tier: skuDb[i]
  }

}]
