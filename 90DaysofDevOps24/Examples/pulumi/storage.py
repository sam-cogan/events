import pulumi
import pulumi_azure_native as azure_native

# Define the component resource class
class StorageAccountComponent(pulumi.ComponentResource):
    def __init__(self, name: str, args: pulumi.ResourceArgs, opts: pulumi.ResourceOptions = None):
        super().__init__('custom:resource:StorageAccountComponent', name, {}, opts)

        # Create an Azure Storage Account
        self.account = azure_native.storage.StorageAccount(
            f"{name}-storageaccount",
            account_name=args.account_name,
            resource_group_name=args.resource_group_name,
            location=args.location,
            sku=azure_native.storage.SkuArgs(name=args.sku_name),
            kind="StorageV2",
            enable_https_traffic_only= True,
            opts=pulumi.ResourceOptions(parent=self)
        )

        # Export the storage account name
        self.register_outputs({"primary_endpoints": self.account.primary_endpoints})

# StorageAccountComponentArgs used to define input properties for the custom component
class StorageAccountComponentArgs(pulumi.ResourceArgs):
    resource_group_name = pulumi.Input[str]
    account_name = pulumi.Input[str]
    location = pulumi.Input[str]
    sku_name = pulumi.Input[str]
