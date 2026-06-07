
@description('Project name to be as prefix')
@minLength(2)
@maxLength(10)
param projectName string


@description('Environment for the deployment')
@allowed([
  'dev'
  'staging'
  'prod'
])
param environment string = 'dev'

@description('location of the resource deployment')
param location string = resourceGroup().location

@description('skuName for the resource')
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param skuName string = 'Standard_LRS'

var storageName = '${projectName}${environment}sa'
var commonTags  = {
  environment: environment
  project: projectName
  createdBy: 'Ashish Arya'
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name: storageName
  location: location
  sku: {name: skuName}
  kind: 'StorageV2'
  tags: commonTags
}

output storageAccountId string = storageAccount.id
output storageAccountNama string = storageAccount.name
output blobEndpoint string = storageAccount.properties.primaryEndpoints.blob
