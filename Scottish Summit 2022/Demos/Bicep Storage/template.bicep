param storageacccountname string = 'storage'
var storageaccountsku = 'LRS'

resource StorageAccountName_resource 'Microsoft.Storage/storageAccounts@2018-07-01' = {
  name: storageacccountname
  location: resourceGroup().location
  tags: {
    displayName: storageacccountname
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

