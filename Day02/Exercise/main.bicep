
resource stgaccount 'Microsoft.Storage/storageAccounts@2026-04-01' = {
  name : 'mystg${uniqueString(resourceGroup().id)}'
  location: resourceGroup().location
  sku:{
    name: 'Standard_LRS'
  }
  kind:'StorageV2'
  tags: {
    environment : 'dev'
    project : 'IACTraining-day2'
    owner : 'Ashish'
  }
}