@description('Location')
param location string = resourceGroup().location

@description('Hub VNet name')
param hubVnetName string = 'hub-vnet'

@description('Resource group name')
param rg string = 'bk-group'

// ---------------- EXISTING HUB VNET + SUBNET ----------------
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVnetName
  scope: resourceGroup(rg)
}

resource bastionSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: 'AzureBastionSubnet'
  parent: hubVnet
}

// ---------------- PUBLIC IP FOR BASTION ----------------
resource bastionPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'bastion-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// ---------------- BASTION HOST ----------------
resource bastionHost 'Microsoft.Network/bastionHosts@2023-09-01' = {
  name: 'bastion-host'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'bastion-ipconfig'
        properties: {
          subnet: {
            id: bastionSubnet.id
          }
          publicIPAddress: {
            id: bastionPip.id
          }
        }
      }
    ]
  }
}

