@description('Location for monitoring resources')
param location string = resourceGroup().location

@description('Log Analytics Workspace name')
param lawName string = 'hub-monitor-law'

@description('Azure Firewall name')
param firewallName string = 'hub-firewall'

@description('Bastion name')
param bastionName string = 'bastion-host'

@description('NSG names to enable flow logs on')
param nsgNames array = [
  'prod-vm-nsg'
  'stage-vm-nsg'
]

@description('Route table names to monitor')
param routeTableNames array = [
  'rt-prod-to-fw'
  'rt-stage-to-fw'
]

//
// ---------------- LOG ANALYTICS WORKSPACE ----------------
//
resource logAnalytics 'Microsoft.OperationalInsights/workspaces@2023-09-01' = {
  name: lawName
  location: location
  sku: {
    name: 'PerGB2018'
  }
  properties: {
    retentionInDays: 30
  }
}

//
// ---------------- NETWORK WATCHER ----------------
//
resource networkWatcher 'Microsoft.Network/networkWatchers@2023-09-01' = {
  name: 'NetworkWatcher_${location}'
  location: location
}

//
// ---------------- FIREWALL DIAGNOSTICS ----------------
//
resource firewall 'Microsoft.Network/azureFirewalls@2023-09-01' existing = {
  name: firewallName
}

resource firewallDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'firewall-diag'
  scope: firewall
  properties: {
    workspaceId: logAnalytics.id
    logs: [
      {
        category: 'AzureFirewallApplicationRule'
        enabled: true
      }
      {
        category: 'AzureFirewallNetworkRule'
        enabled: true
      }
      {
        category: 'AzureFirewallDnsProxy'
        enabled: true
      }
    ]
    metrics: [
      {
        category: 'AllMetrics'
        enabled: true
      }
    ]
  }
}

//
// ---------------- BASTION DIAGNOSTICS ----------------
//
resource bastion 'Microsoft.Network/bastionHosts@2023-09-01' existing = {
  name: bastionName
}

resource bastionDiag 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = {
  name: 'bastion-diag'
  scope: bastion
  properties: {
    workspaceId: logAnalytics.id
    logs: [
      {
        category: 'BastionAuditLogs'
        enabled: true
      }
    ]
  }
}

//
// ---------------- NSG FLOW LOGS (v2) ----------------
//
resource nsgResources 'Microsoft.Network/networkSecurityGroups@2023-09-01' existing = [
  for nsgName in nsgNames: {
    name: nsgName
  }
]



//
// ---------------- ROUTE TABLE DIAGNOSTICS ----------------
//


output logAnalyticsWorkspaceId string = logAnalytics.id
