

@description('Project Name')
@minLength(2)
@maxLength(10)
param projectName string

@description('Project environment')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

@description('Location of the resource deployment')
param location string = resourceGroup().location


var uniquesuffix = substring(uniqueString(resourceGroup().id),0,6)
var completeName = '${toLower(projectName)}${environment}${uniquesuffix}'
var primaryStorageName = take(completeName,24)

var logsStorageName = '${toLower(projectName)}logs${uniquesuffix}'

var skuName = environment == 'prod' ? 'Standard_GRS' : 'Standard_LRS'

var accessTier = environment == 'prod' ? 'Hot' : 'Cool'

var commonTags = {
  environment : environment
  project : projectName
  uniqueId : resourceGroup().id
  region : resourceGroup().location
}


resource stgaccountfirst 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: primaryStorageName
  location: location
  sku: {
    name : skuName
  }
  kind : 'StorageV2'
  tags: commonTags
}

resource stgaccountsecond 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: logsStorageName
  location: location
  kind : 'BlobStorage'
  sku: {name:skuName}
  properties:{
    accessTier: accessTier
  }
  tags: commonTags
}


output primaryStorageName string = stgaccountfirst.name
output logsStorageName string = stgaccountsecond.name
output primaryBlobEndpoint string = stgaccountfirst.properties.primaryEndpoints.blob
output environmentConfig object = {
  sku: stgaccountsecond.sku
  accessTier: stgaccountsecond.properties.accessTier
  region: stgaccountsecond.location
}
