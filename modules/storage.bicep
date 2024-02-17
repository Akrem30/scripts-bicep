param location string
param storageSku string 
param storageName string
param kind string
@allowed(['Cool','Hot','Premium'])
param accessTier string
param containerName string
resource storage 'Microsoft.Storage/storageAccounts@2023-01-01' = {
  kind:kind
  location:location
  name: storageName
  sku:{
    name:storageSku
  }
  properties:{
    isHnsEnabled:true
    accessTier: accessTier
  }

}
resource blobService 'Microsoft.Storage/storageAccounts/blobServices@2023-01-01' = {
  name: 'default'
  parent: storage
  properties: {
    deleteRetentionPolicy:{
      allowPermanentDelete:false
      days: 8
      enabled:true
    }
      
}
}
resource container 'Microsoft.Storage/storageAccounts/blobServices/containers@2023-01-01' = {
  name: containerName
  parent: blobService
  properties: {
   publicAccess:'None'  
  }
}
