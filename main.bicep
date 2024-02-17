
param location string = resourceGroup().location
// Paramètres webbapps et des plans de service
var webApps = [
   { name: 'api-documents', sku: 'F1' }
   { name: 'api-emplois', sku: 'F1' }
   { name: 'api-favoris', sku: 'F1' }
   { name: 'api-postulations', sku: 'B1' }
   { name: 'modern-recrut', sku: 'S1' }
 ]

//Paramètres base de données
 var skuDb  = ['Standard','Basic'] 
var namesDbs = ['postulations','emplois']  
param nameServer string = 'dbServer'
param dbUser string               
@secure()
@minLength(10)
@maxLength(20)
param dbPassword string

// Paramètres du compte de stockage
param storageSku string = 'Standard_ZRS'
param storageName string = 'storageaccdocuments'
param containerName string = 'documents'
param kind string = 'StorageV2'
param accessTier string = 'Cool'

// Création des apps services et des plans de service
module webApplications 'modules/appServices.bicep' = [for webApp in webApps : {
                name: webApp.name
                params: {
                  location: location
                  webAppName: webApp.name
                   sku: webApp.sku
                }
              } ]


//Création du serveur et des bases de données
module dataBases 'modules/sqldb.bicep' = {
      name: 'databases' 
      params:{
         location:location
         namesDbs: namesDbs
         dbUser:dbUser
         dbPassword:dbPassword
         skuDb: skuDb
         nameServer:nameServer
      }
   }
// Création du compte de stockage 
module storage 'modules/storage.bicep'={
   name : storageName
   params:{
      kind:kind
      storageSku:storageSku
      storageName:storageName
      location:location
      accessTier: accessTier
      containerName:containerName
   }
}
