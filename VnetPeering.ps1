$VNET1 = Get-AzVirtualNetwork -Name Vnet-1111 -ResourceGroupName RG-ARM
$VNET2= Get-AzVirtualNetwork -Name Vnet-1111 -ResourceGroupName RG-ARM

$peer12 = Add-AzVirtualNetworkPeering -Name "conn-1-2" -VirtualNetwork $VNET1 -RemoteVirtualNetworkId $VNET2.Id
$peer21 = Add-AzVirtualNetworkPeering -Name "Conn2-1" -VirtualNetwork $VNET2 -RemoteVirtualNetworkId $VNET1.Id