param storageacccountname string = 'storage'
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param storageaccountsku string = 'Standard_LRS'

resource StorageAccountName_resource 'Microsoft.Storage/storageAccounts@2018-07-01' = {
  name: storageacccountname
  location: resourceGroup().location
  tags: {
    displayName: storageacccountname
  }
  sku: {
    name: storageaccountsku
  }
  kind: 'StorageV2'
}

