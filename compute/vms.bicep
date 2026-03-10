@description('Admin username')
param adminUsername string = 'azureuser'

@description('Admin password')
@secure()
param adminPassword string

param location string = resourceGroup().location

// ---------------- VM1 SETTINGS ----------------
param vm1Name string = 'prod-vm'
param vm1VnetName string = 'prod-vnet'
param vm1SubnetName string = 'prod-default'

// ---------------- VM2 SETTINGS ----------------
param vm2Name string = 'stage-vm'
param vm2VnetName string = 'stage-vnet'
param vm2SubnetName string = 'stage-default'


// ---------------- EXISTING VNets + Subnets ----------------
resource vnet1 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vm1VnetName
}

resource subnet1 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: vm1SubnetName
  parent: vnet1
}

resource vnet2 'Microsoft.Network/virtualNetworks@2023-09-01' existing = {
  name: vm2VnetName
}

resource subnet2 'Microsoft.Network/virtualNetworks/subnets@2023-09-01' existing = {
  name: vm2SubnetName
  parent: vnet2
}


// ---------------- PUBLIC IPs ----------------
resource pip1 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${vm1Name}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

resource pip2 'Microsoft.Network/publicIPAddresses@2023-09-01' = {
  name: '${vm2Name}-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}




// ---------------- NSGs ----------------
resource nsg1 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vm1Name}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource nsg2 'Microsoft.Network/networkSecurityGroups@2023-09-01' = {
  name: '${vm2Name}-nsg'
  location: location
  properties: {
    securityRules: [
      {
        name: 'AllowRDP'
        properties: {
          priority: 1000
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}


// ---------------- NICs ----------------
resource nic1 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${vm1Name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: { id: pip1.id }
          subnet: { id: subnet1.id }
        }
      }
    ]
    networkSecurityGroup: { id: nsg1.id }
  }
}

resource nic2 'Microsoft.Network/networkInterfaces@2023-09-01' = {
  name: '${vm2Name}-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: { id: pip2.id }
          subnet: { id: subnet2.id }
        }
      }
    ]
    networkSecurityGroup: { id: nsg2.id }
  }
}


// ---------------- WINDOWS VMs ----------------
resource vm1 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vm1Name
  location: location
  properties: {
    hardwareProfile: {
  vmSize: 'Standard_D2s_v3'
}

    osProfile: {
      computerName: vm1Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: { enableAutomaticUpdates: true }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Standard_LRS' }
      }
    }
    networkProfile: {
      networkInterfaces: [ { id: nic1.id } ]
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2023-09-01' = {
  name: vm2Name
  location: location
  properties: {
   hardwareProfile: {
  vmSize: 'Standard_D2s_v3'
}

    osProfile: {
      computerName: vm2Name
      adminUsername: adminUsername
      adminPassword: adminPassword
      windowsConfiguration: { enableAutomaticUpdates: true }
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: { storageAccountType: 'Standard_LRS' }
      }
    }
    networkProfile: {
      networkInterfaces: [ { id: nic2.id } ]
    }
  }
}

output vm1PublicIp string = pip1.properties.ipAddress
output vm2PublicIp string = pip2.properties.ipAddress
