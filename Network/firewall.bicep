@description('Location')
param location string = resourceGroup().location

@description('Hub VNet name')
param hubVnetName string = 'hub-vnet'

@description('Resource group name')
param rg string = 'bk-group'

// ---------------- EXISTING HUB VNET + FIREWALL SUBNET ----------------
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVnetName
  scope: resourceGroup(rg)
}

resource firewallSubnet 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: 'AzureFirewallSubnet'
  parent: hubVnet
}

// ---------------- PUBLIC IP FOR FIREWALL ----------------
resource firewallPip 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: 'firewall-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// ---------------- FIREWALL ----------------
resource azureFirewall 'Microsoft.Network/azureFirewalls@2023-09-01' = {
  name: 'hub-firewall'
  location: location
  properties: {
    sku: {
      name: 'AZFW_VNet'
      tier: 'Standard'
    }
    ipConfigurations: [
      {
        name: 'firewall-ipconfig'
        properties: {
          subnet: {
            id: firewallSubnet.id
          }
          publicIPAddress: {
            id: firewallPip.id
          }
        }
      }
    ]
  }
}

output firewallPublicIp string = firewallPip.properties.ipAddress

