@description('Location of the resources')
param location string = resourceGroup().location

@description('Prod VNet name (already created)')
param prodVnetName string ='prod-vnet'

@description('Stage VNet name (already created)')
param stageVnetName string ='stage-vnet'

@description('Prod subnet name inside prod VNet')
param prodSubnetName string = 'prod-default'

@description('Stage subnet name inside stage VNet')
param stageSubnetName string ='stage-default'

@description('Prod subnet address prefix (must match existing)')
param prodSubnetPrefix string ='10.30.0.0/25'

@description('Stage subnet address prefix (must match existing)')
param stageSubnetPrefix string ='10.40.0.0/25'

@description('Firewall private IP in hub VNet')
param firewallPrivateIp string ='10.20.2.4'

// Existing VNets
resource prodVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: prodVnetName 
}

resource stageVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: stageVnetName
}

// Route table for PROD
resource prodRouteTable 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-prod-to-fw'
  location: location
  properties: {
    routes: [
      {
        name: 'default-to-firewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}

// Route table for STAGE
resource stageRouteTable 'Microsoft.Network/routeTables@2023-09-01' = {
  name: 'rt-stage-to-fw'
  location: location
  properties: {
    routes: [
      {
        name: 'default-to-firewall'
        properties: {
          addressPrefix: '0.0.0.0/0'
          nextHopType: 'VirtualAppliance'
          nextHopIpAddress: firewallPrivateIp
        }
      }
    ]
  }
}

// Associate route table to PROD subnet
resource prodSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: prodSubnetName
  parent: prodVnet
  properties: {
    addressPrefix: prodSubnetPrefix
    routeTable: {
      id: prodRouteTable.id
    }
    // keep NSG if you already have one by adding:
    // networkSecurityGroup: {
    //   id: '<nsg-resource-id>'
    // }
  }
}

// Associate route table to STAGE subnet
resource stageSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' = {
  name: stageSubnetName
  parent: stageVnet
  properties: {
    addressPrefix: stageSubnetPrefix
    routeTable: {
      id: stageRouteTable.id
    }
    // networkSecurityGroup: {
    //   id: '<nsg-resource-id>'
    // }
  }
}
