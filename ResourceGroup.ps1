#Get Azure Modules in Powershell
Install-Module Az
Import-Module Az

#Login to your Azure Account
Connect-AzAccount
#Select the Subscription you wish to work on
Select-AzSubscription -Subscription "Free Trial"

#Define Variables
$ResourceGroupName = "MyRG1"
$Location = "West Europe"

#Create New Resource Group
$RG=New-AzResourceGroup -Name $ResourceGroupName -Location $Location

#Print The Resource Group Name and Location
Write-host $RG.ResourceGroupName
Write-host $RG.Location

#Get the details of an existing resource group
$RGGet = Get-AzResourceGroup -Name $ResourceGroupName

Write-host $RGGet.ResourceGroupName
Write-host $RGGet.Location

#Delete a Resource Group
Remove-AzResourceGroup -Name $RG.ResourceGroupName