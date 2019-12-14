#Login to your azure account
Connect-AzAccount 
#select the subscription you wish to work on
Select-AzSubscription -Subscription "Free Trial"

#set up resource group
$rgname= "RG-Vnet-PS"
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


#Create Virtual Network
$vnetname = "vnet-PS"
$addressSpace ="10.0.0.0/24"
$virtualNetwork = New-AzVirtualNetwork `
  -ResourceGroupName $rg.ResourceGroupName `
  -Location $rg.Location`
  -Name $vnetname `
  -AddressPrefix $addressSpace

#Create Subnet
#Get VNet details where subnet is to be created
$vnet= Get-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rg.ResourceGroupName

#variables for creating Subnet
$subnetname ="Subnet-PS"
$subnetaddressprefix ="10.0.0.0/28"

#cmdlet for creating subnet configuration
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
-Name $subnetname `
-AddressPrefix $subnetaddressprefix `
-VirtualNetwork $vnet

#Saving the subnet configuration on VNET
Set-AzVirtualNetwork -VirtualNetwork $vnet


#Create Gateway Subnet
$gatewaysubnetaddressprefix = "10.0.0.248/29"

$vnet= Get-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rg.ResourceGroupName
$subnetConfig = Add-AzVirtualNetworkSubnetConfig `
-Name 'GatewaySubnet' `
-AddressPrefix $gatewaysubnetaddressprefix `
-VirtualNetwork $vnet

$vnet | Set-AzVirtualNetwork

#Create Public IP
$publicIPName = $vnetname + "-PIP"
$gwpip= New-AzPublicIpAddress -Name $publicIPName -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location`
 -AllocationMethod Dynamic

#Create Gateway IPConfig 
$vnet = Get-AzVirtualNetwork -Name $vnetname -ResourceGroupName $rg.ResourceGroupName
$subnet = Get-AzVirtualNetworkSubnetConfig -Name 'GatewaySubnet' -VirtualNetwork $vnet
$gwipconfig = New-AzVirtualNetworkGatewayIpConfig -Name gwipconfig1 -SubnetId $subnet.Id -PublicIpAddressId $gwpip.Id

#Create Gateway
$vnetgwname =$vnetname + "-GW"
New-AzVirtualNetworkGateway -Name $vnetgwname -ResourceGroupName $rg.ResourceGroupName -Location $rg.Location`
 -IpConfigurations $gwipconfig -GatewayType Vpn -VpnType RouteBased -GatewaySku Basic