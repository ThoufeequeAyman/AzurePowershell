Login-AzureRmAccount

$rgname= "itrain-rg-vnet-aks"
$rglocation= "South India"
$rg= Get-AzureRmResourceGroup -Name $rgname -ErrorAction
if(!$rg)
{
Write-Host "creating new resouce group"
$rg =New-AzureRmResourceGroup -name $rgname -location $rglocation -ErrorAction Ignore
}
else
{
Write-Host "Resouce group already exist"
}


$GWName1 = "firstGW"
$GWName2 ="SecondGW"
$vnet1gw = Get-AzureRmVirtualNetworkGateway -Name $GWName1 -ResourceGroupName $rg.ResourceGroupName
$vnet2gw = Get-AzureRmVirtualNetworkGateway -Name $GWName2 -ResourceGroupName $rg.ResourceGroupName
$Connection12="con-FirtsGW-to-SecondGW"
$Connection21="con-SecondGW-to-firstGW"

New-AzureRmVirtualNetworkGatewayConnection `
-Name $Connection12 `
-ResourceGroupName $rg.ResourceGroupName `
-VirtualNetworkGateway1 $vnet1gw `
-VirtualNetworkGateway2 $vnet2gw `
-Location $rg.Location `
-ConnectionType Vnet2Vnet `
-SharedKey 'AzureA1b2C3'

New-AzureRmVirtualNetworkGatewayConnection `
-Name $Connection21 `
-ResourceGroupName $rg.ResourceGroupName `
-VirtualNetworkGateway1 $vnet2gw `
-VirtualNetworkGateway2 $vnet1gw `
-Location $rg.Location `
-ConnectionType Vnet2Vnet `
-SharedKey 'AzureA1b2C3'