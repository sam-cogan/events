open Farmer
open Farmer.Builders
open Farmer.Storage

let storageAcc = storageAccount {
    name "blogtablestoragedemo"
    sku Storage.Sku.Standard_LRS
}


let deployment = arm {
    location Location.WestEurope
    add_resource storageAcc
    output "storageKey" storageAcc.Key
}

let deployedResources = deployment |> Deploy.execute "blogtabledeployment" []

let connectionString = deployedResources.["storageKey"]