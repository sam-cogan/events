storage_account_component = StorageAccountComponent(
    "myStorageAccountComponent",
    args=StorageAccountComponentArgs(
        resource_group_name="myResourceGroup",
        account_name="myuniquestorageacct",
        location="WestUS",
        sku_name="Standard_LRS"
    )
)