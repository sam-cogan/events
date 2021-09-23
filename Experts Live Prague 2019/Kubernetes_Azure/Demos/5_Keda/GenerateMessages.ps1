
param (
    [int]$count= 9 

)

$storageAccount=Get-AzStorageAccount -ResourceGroupName "keda" -Name "kedademo01"
$ctx = $storageAccount.Context
$queue = Get-AzStorageQueue –Name $queueName –Context $ctx
# Create a new message using a constructor of the CloudQueueMessage class


for($i=0; $i -lt $($count+1); $i++ ){
    $queueMessage = New-Object -TypeName "Microsoft.Azure.Storage.Queue.CloudQueueMessage,$($queue.CloudQueue.GetType().Assembly.FullName)" -ArgumentList "This is message 1"
    $queue.CloudQueue.AddMessageAsync($QueueMessage)
}
