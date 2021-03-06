param keyVaultName string {
  metadata: {
    description: 'Specifies the name of the key vault.'
  }
}
param location string {
  default: resourceGroup().location
  metadata: {
    description: 'Specifies the Azure location where the key vault should be created.'
  }
}

param enabledForDeployment bool {
  default: false
  metadata: {
    description: 'Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the key vault.'
  }
}

param enabledForDiskEncryption bool {
  default: false
  metadata: {
    description: 'Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys.'
  }
}

param enabledForTemplateDeployment bool {
  default: false
  metadata: {
    description: 'Specifies whether Azure Resource Manager is permitted to retrieve secrets from the key vault.'
  }
}

param tenantId string {
  default: subscription().tenantId
  metadata: {
    description: 'Specifies the Azure Active Directory tenant ID that should be used for authenticating requests to the key vault. Get it by using Get-AzSubscription cmdlet.'
  }
}

param objectId string {
  metadata: {
    description: 'Specifies the object ID of a user, service principal or security group in the Azure Active Directory tenant for the vault. The object ID must be unique for the list of access policies. Get it by using Get-AzADUser or Get-AzADServicePrincipal cmdlets.'
  }
}

param keysPermissions array {
  default: [
    'list'
  ]
  metadata: {
    description: 'Specifies the permissions to keys in the vault. Valid values are: all, encrypt, decrypt, wrapKey, unwrapKey, sign, verify, get, list, create, update, import, delete, backup, restore, recover, and purge.'
  }
}

param secretsPermissions array {
  default: [
    'list'
  ]
  metadata: {
    description: 'Specifies the permissions to secrets in the vault. Valid values are: all, get, list, set, delete, backup, restore, recover, and purge.'
  }
}

param skuName string {
  default: 'standard'
  allowed: [
    'standard'
    'premium'
  ]
  metadata: {
    description: 'Specifies whether the key vault is a standard vault or a premium vault.'
  }
}

param secretsObject object {
  secure: true
  default: {
    secrets: []
  }
  metadata: {
    description: 'Specifies all secrets {"secretName":"","secretValue":""} wrapped in a secure object.'
  }
}

param globalRedundancy bool = false

resource vault 'Microsoft.KeyVault/vaults@2019-06-01' = {
  name: toLower('${keyVaultName}-kv')
  location: location
  tags: {
    displayName: 'KeyVault'
  }
  properties: {
    enabledForDeployment: enabledForDeployment
    enabledForTemplateDeployment: enabledForTemplateDeployment
    enabledForDiskEncryption: enabledForDiskEncryption
    tenantId: subscription().tenantId
    accessPolicies: [
      {
        objectId: objectId
        tenantId: subscription().tenantId
        permissions: {
          keys: keysPermissions
          secrets: secretsPermissions
        }
      }
    ]
    sku: {
      name: skuName
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

var firstSecretName = first(secretsObject.secrets).secretName
var firstSecretValue = first(secretsObject.secrets).secretValue

resource secret 'Microsoft.KeyVault/vaults/secrets@2019-09-01' = {
  name: '${vault.name}/${firstSecretName}'
  properties: {
    value: firstSecretValue
  }
}


resource stg 'Microsoft.Storage/storageAccounts@2019-06-01' = {
  name: toLower('${keyVaultName}-stg')
  location: vault.location
  kind: 'Storage'
  sku: {
      name: globalRedundancy ? 'Standard_GRS' : 'Standard_LRS'
  }
}

output blobEndpoint string = stg.properties.primaryEndpoints.blob