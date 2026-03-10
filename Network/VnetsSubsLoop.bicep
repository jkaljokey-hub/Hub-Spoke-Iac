@description('Location for all resources')
param location string = resourceGroup().location

// =======================================================
// DEFINE ALL YOUR VNets + SUBNETS HERE
// Edit only this section
// =======================================================
param vnets array = [
  // ---------------- HUB VNET ----------------
  {
    name: 'hub-vnet'
    addressPrefix: '10.20.0.0/16'
    subnets: [
      {
        name: 'hub-default'
        prefix: '10.20.0.0/24'
      }
      {
        name: 'AzureBastionSubnet'
        prefix: '10.20.1.0/26'
      }
      {
        name: 'AzureFirewallSubnet'
        prefix: '10.20.2.0/26'
      }
    ]
  }

  // ---------------- SPOKE 1 ----------------
  {
    name: 'prod-vnet'
    addressPrefix: '10.30.0.0/24'
    subnets: [
      {
        name: 'prod-default'
        prefix: '10.30.0.0/25'
      }
    ]
  }

  // ---------------- SPOKE 2 ----------------
  {
    name: 'stage-vnet'
    addressPrefix: '10.40.0.0/24'
    subnets: [
      {
        name: 'stage-default'
        prefix: '10.40.0.0/25'
      }
    ]
  }


]

// =======================================================
// CREATE ALL VNets + SUBNETS USING LOOPS
// =======================================================
resource vnetResources 'Microsoft.Network/virtualNetworks@2023-09-01' = [
  for v in vnets: {
    name: v.name
    location: location
    properties: {
      addressSpace: {
        addressPrefixes: [
          v.addressPrefix
        ]
      }
      subnets: [
        for s in v.subnets: {
          name: s.name
          properties: {
            addressPrefix: s.prefix
          }
        }
      ]
    }
  }
]


