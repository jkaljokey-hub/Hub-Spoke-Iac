param hubVnetName string = 'hub-vnet'
param prodVnetName string = 'prod-vnet'
param stageVnetName string = 'stage-vnet'

param rg string = 'bk-group'

// ---------------- EXISTING VNets ----------------

resource hubVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: hubVnetName
  scope: resourceGroup(rg)
}

resource prodVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: prodVnetName
  scope: resourceGroup(rg)
}

resource stageVnet 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: stageVnetName
  scope: resourceGroup(rg)
}

// ---------------- HUB <-> PROD ----------------

resource hubToProd 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${hubVnet.name}/hub-to-${prodVnetName}'
  properties: {
    remoteVirtualNetwork: {
      id: prodVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource prodToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${prodVnet.name}/prod-to-${hubVnetName}'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

// ---------------- HUB <-> STAGE ----------------

resource hubToStage 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${hubVnet.name}/hub-to-${stageVnetName}'
  properties: {
    remoteVirtualNetwork: {
      id: stageVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}

resource stageToHub 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-09-01' = {
  name: '${stageVnet.name}/stage-to-${hubVnetName}'
  properties: {
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
  }
}
