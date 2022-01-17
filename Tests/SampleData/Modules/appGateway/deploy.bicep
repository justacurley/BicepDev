var deploymentName = deployment().name
var resourceGroupName = 'rg-bdfiles'

module appGateway './appGateway.bicep' = {
  name: '${deploymentName}_appGateway'
  params: {
    subnetName:''
    vNetName:''
    name: 'agw-bdfiles'
    sku: 'WAF_v2'
    firewallPolicyId: '/subscriptions/waf'
    capacity: 2
    http2Enabled: true
    frontendPublicIpResourceId: '/subscriptions/pip'
    subnetId: '/subscriptions/sn'
    sslCertificateName: 'star-bdfiles-com'
    sslCertificateKeyVaultSecretId: 'https://kv/secrets/star-bdfiles-com'
    backendPools: [
      {
        backendPoolName: 'pool_pos_0'
        backendAddresses: [
          {
            ipAddress:'192.168.1.24'
          }
          {
            ipAddress:'192.168.1.25'
          }
        ]
      }
    ]
    backendHttpConfigurations: [
      {
        backendHttpConfigurationName: 'httpSettings_pos_8101'
        port: 8101
        protocol: 'https'
        cookieBasedAffinity: 'Enabled'
        pickHostNameFromBackendAddress: false
        probeEnabled: true
      }
    ]
    probes:[
      {
        backendHttpConfigurationName: 'httpSettings_pos_8101'
        protocol: 'https'
        host:'mello-dv2.loandepotdev.works'
        body:''
        path: '/diagnostics/ping'
        interval: 15
        timeout: 2
        unhealthyThreshold: 2
        minServers: 0
        statusCodes: [
          '200-399'
        ]
      }
    ]
    frontendHttpsListeners:[
      {
        frontendListenerName: 'listener_pos_8101'
        frontendIPType: 'Public'
        port: 8101
      }
      {
        frontendListenerName: 'listener_pos_443'
        frontendIPType: 'Public'
        port: 443
      }
    ]
    frontendHttpListeners: [
      {
        frontendListenerName: 'listener_pos_80'
        frontendIPType: 'Public'
        port: 80
      }
    ]
    frontendHttpRedirects:[
      {
        frontendIPType: 'Public'
        port: 80
        frontEndListenerName: 'listener_pos_443'
      }
    ]
    routingRules:[
      {
        frontendListenerName: 'listener_pos_443'
        backendPoolName: 'pool_pos_0'
        backendHttpConfigurationName: 'httpSettings_pos_8101'
      }
      {
        frontendListenerName: 'listener_pos_8101'
        backendPoolName: 'pool_pos_0'
        backendHttpConfigurationName: 'httpSettings_pos_8101'
      }
    ]
    userAssignedIdentities:{
      '85215d48-76bf-4bf4-a759-f43171dc7e01':{}
    }
  }
}
