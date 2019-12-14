Connect-AzAccount

# Variables for common values
$resourceGroup = "lz-rg-eur-d-playground"
$location = "West Europe"
$vmName = "lzvm-eur-c-ps2"
$VNETName = "lzvnet-eur-c-fe"
$subnetName = "dmz-main"
$IsVMPartOfAvailabilitySet = $false
$ISVMassociatedWithPublicIP = $false
$ASName = "as_ps"

If($IsVMPartOfAvailabilitySet)
{
$AvailabilitySet =New-AzAvailabilitySet `
-ResourceGroupName $resourceGroup `
-Name $ASName `
-Location $location `
-PlatformUpdateDomainCount 2 `
-PlatformFaultDomainCount 2 `
-Sku Aligned 
}

# Create user object
$cred = Get-Credential -Message "Enter a username and password for the virtual machine."

# Create a resource group
$rg= Get-AzResourceGroup `
-Name $resourceGroup

# Get virtual network
$vnet = Get-AzVirtualNetwork `
-Name $VNETName `
-ResourceGroupName $resourceGroup

# Get subnet configuration
$subnetConfig = Get-AzVirtualNetworkSubnetConfig `
-Name $subnetName `
-VirtualNetwork $vnet

if($ISVMassociatedWithPublicIP)
{
# Create a public IP address and specify a DNS name
$pip = New-AzPublicIpAddress `
-ResourceGroupName $resourceGroup `
-Location $location `
-Name "mypublicdns$(Get-Random)" `
-AllocationMethod Static `
-IdleTimeoutInMinutes 4 `
-DomainNameLabel "mypsvm1"

# Create a virtual network card and associate with public IP address and NSG
$nic = New-AzNetworkInterface `
-Name "NIC$vmName" `
-ResourceGroupName $resourceGroup `
-Location $location `
-SubnetId $subnetConfig.Id `
-PublicIpAddressId $pip.Id
}

else
{
$nic = New-AzNetworkInterface `
-Name "NIC$vmName" `
-ResourceGroupName $resourceGroup `
-Location $location `
-SubnetId $subnetConfig.Id
}

# Create a virtual machine configuration
$vmConfig = New-AzVMConfig -VMName $vmName -VMSize Standard_D1 -AvailabilitySetId $AvailabilitySet.Id  | `
Set-AzVMOperatingSystem -Windows -ComputerName $vmName -Credential $cred | `
Set-AzVMSourceImage -PublisherName MicrosoftWindowsServer -Offer WindowsServer -Skus 2012-R2-Datacenter -Version latest | `
Add-AzVMNetworkInterface -Id $nic.Id

# Create a virtual machine
New-AzVM -ResourceGroupName $resourceGroup -Location $location -VM $vmConfig