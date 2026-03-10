// EXISTING VNET
resource prodVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: prodVnetName
}

// ASSOCIATE ROUTE TABLE WITH SUBNET
resource subnetUpdate 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  parent: prodVnet
  name: prodSubnetName
  properties: {
    routeTable: {
      id: prodRouteTable.id
    }
  }
}
