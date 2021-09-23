param keyVaultName string {
  metadata: {
    description: 'Name of KeyVault to Store SaS Token'
  }
}
param tenantID string {
  metadata: {
    description: 'Azure AD Tenant ID'
  }
}
param keyVaultAccessObjectID string {
  metadata: {
    description: 'ID of user or App to grant access to KV'
  }
}
param StorageAccountName string {
  metadata: {
    description: 'Name of Storage Account to Create'
  }
}
param accountSasProperties object = {
  signedServices: 'b'
  signedPermission: 'rw'
  signedExpiry: '01/03/2019 00:00:01'
  signedResourceTypes: 'o'
}

resource StorageAccountName_resource 'Microsoft.Storage/storageAccounts@2018-07-01' = {
  name: StorageAccountName
  location: resourceGroup().location
  tags: {
    displayName: StorageAccountName
  }
  sku: {
    name: 'Standard_LRS'
  }
  kind: 'StorageV2'
}

resource keyVaultName_resource 'Microsoft.KeyVault/vaults@2018-02-14' = {
  name: keyVaultName
  location: resourceGroup().location
  tags: {
    displayName: keyVaultName
  }
  properties: {
    enabledForDeployment: true
    enabledForTemplateDeployment: true
    enabledForDiskEncryption: true
    tenantId: tenantID
    accessPolicies: [
      {
        tenantId: tenantID
        objectId: keyVaultAccessObjectID
        permissions: {
          keys: [
            'get'
          ]
          secrets: [
            'list'
            'get'
            'set'
          ]
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
  }
}

resource keyVaultName_StorageSaSToken 'Microsoft.KeyVault/vaults/secrets@2018-02-14' = {
  name: '${keyVaultName_resource.name}/StorageSaSToken'
  properties: {
    value: listAccountSas(StorageAccountName, '2018-07-01', accountSasProperties).accountSasToken
  }
}