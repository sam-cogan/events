module storage1 'StorageModule.bicep' ={
  name: 'storage1'
  params:{
    location: 'westeurope'
    storagePrefix:'stg'
    storageSKU: 'Standard_LRS'
  }
}
