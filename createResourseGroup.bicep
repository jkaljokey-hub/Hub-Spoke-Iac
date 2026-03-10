targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'bk-group'
  location: 'KoreaCentral'
  tags: {
    environment: 'dev'
    owner: 'abubakar'
  }
}



