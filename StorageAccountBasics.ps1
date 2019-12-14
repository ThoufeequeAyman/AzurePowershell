Connect-AzAccount
Select-AzSubscription -Subscription "Itrain-Dev"
#Create Resource Group
$rgname = "RG-Storage"
$rglocation= "South India"

$rg= Get-AzResourceGroup -Name $rgname -ErrorAction SilentlyContinue
if(!$rg)
{
Write-Host "creating new resouce group"
$rg =New-AzResourceGroup -name $rgname -location $rglocation 
}
else
{
Write-Host "Resouce group already exist"
}

$storageAccount = New-AzStorageAccount -ResourceGroupName $rg.ResourceGroupName `
  -Name "strakshay2" `
  -Location $rg.Location `
  -SkuName Standard_LRS `
  -Kind StorageV2 `
  -AccessTier Hot 
$storageAccount = Get-AzStorageAccount -ResourceGroupName RG-Storage -Name strakshay3

$ctx = $storageAccount.Context

$containerName = "blobs1"
New-AzureStorageContainer -Name $containerName -Context $ctx -Permission Container

$queueName = "queue1"
New-AzureStorageQueue -Name $queueName -Context $ctx 

$tableName ="table1"
New-AzureStorageTable -Name $tableName -Context $ctx

$shareName ="sharefile"
New-AzureStorageShare -Name $shareName -Context $ctx