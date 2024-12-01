param location string = 'westeurope'
param prefix string
@allowed([
  'Standard_LRS'
  'Standard_GRS'
  'Standard_ZRS'
])
param storageaccountsku string = 'Standard_LRS'


resource storageaccount 'Microsoft.Storage/storageAccounts@2021-02-01' = {
  name: '${prefix}stg${substring(uniqueString(resourceGroup().id), 0, 6)}'
  location: location
  kind: 'StorageV2'
  sku: {
    name: storageaccountsku
  }
}

resource appServicePlan 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: '${prefix}appServicePlan'
  location: location
  sku: {
    name: 'B1'
    capacity: 1
  }
}

resource appInsightsComponents 'Microsoft.Insights/components@2020-02-02' = {
  name: '${prefix}insights'
  location: location
  kind: 'web'
  properties: {
    Application_Type: 'web'
  }
}


resource azureFunction 'Microsoft.Web/sites@2020-12-01' = {
  name: '${prefix}functionapp'
  location: location
  kind: 'functionapp'
  properties: {
    serverFarmId: appServicePlan.id
    siteConfig: {
      appSettings: [
        {
          name: 'AzureWebJobsDashboard'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageaccount.name};AccountKey=${storageaccount.listKeys().keys[0].value}'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageaccount.name};AccountKey=${storageaccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTAZUREFILECONNECTIONSTRING'
          value: 'DefaultEndpointsProtocol=https;AccountName=${storageaccount.name};AccountKey=${storageaccount.listKeys().keys[0].value}'
        }
        {
          name: 'WEBSITE_CONTENTSHARE'
          value: toLower('name')
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~2'
        }
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: reference(appInsightsComponents.id, '2015-05-01').InstrumentationKey
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'dotnet'
        }
      ]
    }
  }
}
