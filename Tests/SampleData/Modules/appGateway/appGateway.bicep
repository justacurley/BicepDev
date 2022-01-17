@description('Required. The name to be used for the Application Gateway.')
param name string

@description('Optional. The name of the SKU for the Application Gateway.')
@allowed([
  'Standard_Small'
  'Standard_Medium'
  'Standard_Large'
  'WAF_Medium'
  'WAF_Large'
  'Standard_v2'
  'WAF_v2'
])
param sku string = 'WAF_Medium'

@description('Optional. The number of Application instances to be configured.')
@minValue(1)
@maxValue(10)
param capacity int = 2

@description('Optional. Enables HTTP/2 support.')
param http2Enabled bool = true

@description('Optional. PublicIP Resource ID used in Public Frontend.')
param frontendPublicIpResourceId string = '' // dont create public frontend config, do create if not empty

@description('Required. Resource ID of shared firewall policy.')
param firewallPolicyId string

@metadata({
  description: 'Optional. The private IP within the Application Gateway subnet to be used as frontend private address.'
  limitations: 'The IP must be available in the configured subnet. If empty, allocation method will be set to dynamic. Once a method (static or dynamic) has been configured, it cannot be changed'
})
param frontendPrivateIpAddress string = '' //dont create private frontend config

@description('Required. The name of the Virtual Network where the Application Gateway will be deployed.')
param vNetName string

@description('Required. The name of Gateway Subnet Name where the Application Gateway will be deployed.')
param subnetName string

param subnetId string

@description('Optional. The name of the Virtual Network Resource Group where the Application Gateway will be deployed.')
param vNetResourceGroup string = resourceGroup().name

@description('Optional. The Subscription ID of the Virtual Network where the Application Gateway will be deployed.')
param vNetSubscriptionId string = subscription().subscriptionId

@description('Optional. The ID(s) to assign to the resource.')
param userAssignedIdentities object = {}

@description('Optional. Application Gateway IP configuration name.')
param gatewayIpConfigurationName string = 'gatewayIpConfiguration01'

@description('Optional. SSL certificate reference name for a certificate stored in the Key Vault to configure the HTTPS listeners.')
param sslCertificateName string = 'sslCertificate01'

@description('Optional. Secret ID of the SSL certificate stored in the Key Vault that will be used to configure the HTTPS listeners.')
param sslCertificateKeyVaultSecretId string = ''

@description('Required. The backend pools to be configured.')
param backendPools array

@description('Required. The backend HTTP settings to be configured. These HTTP settings will be used to rewrite the incoming HTTP requests for the backend pools.')
param backendHttpConfigurations array

@description('Optional. The backend HTTP settings probes to be configured.')
param probes array = []

@description('Required. The frontend http listeners to be configured.')
param frontendHttpListeners array = []

@description('Required. The frontend HTTPS listeners to be configured.')
param frontendHttpsListeners array = []

@description('Optional. The http redirects to be configured. Each redirect will route http traffic to a predefined frontEnd HTTPS listener.')
param frontendHttpRedirects array = []

@description('Required. The routing rules to be configured. These rules will be used to route requests from frontend listeners to backend pools using a backend HTTP configuration.')
param routingRules array

@description('Optional. Location for all Resources.')
param location string = resourceGroup().location

@description('Optional. Specifies the number of days that logs will be kept for; a value of 0 will retain data indefinitely.')
@minValue(0)
@maxValue(365)
param diagnosticLogsRetentionInDays int = 365

@description('Optional. Resource ID of the diagnostic storage account.')
param diagnosticStorageAccountId string = ''

@description('Optional. Resource ID of log analytics.')
param workspaceId string = ''

@description('Optional. Resource ID of the event hub authorization rule for the Event Hubs namespace in which the event hub should be created or streamed to.')
param eventHubAuthorizationRuleId string = ''

@description('Optional. Name of the event hub within the namespace to which logs are streamed. Without this, an event hub is created for each log category.')
param eventHubName string = ''

@allowed([
  'CanNotDelete'
  'NotSpecified'
  'ReadOnly'
])
@description('Optional. Specify the type of lock.')
param lock string = 'NotSpecified'

@description('Optional. Array of role assignment objects that contain the \'roleDefinitionIdOrName\' and \'principalId\' to define RBAC role assignments on this resource. In the roleDefinitionIdOrName attribute, you can provide either the display name of the role definition, or its fully qualified ID in the following format: \'/providers/Microsoft.Authorization/roleDefinitions/c2f4ef07-c644-48eb-af81-4b1b4947fb11\'')
param roleAssignments array = []

@description('Optional. Tags of the resource.')
param tags object = {}

@description('Optional. Customer Usage Attribution ID (GUID). This GUID must be previously registered.')
param cuaId string = ''

@description('Optional. The name of logs that will be streamed.')
@allowed([
  'ApplicationGatewayAccessLog'
  'ApplicationGatewayPerformanceLog'
  'ApplicationGatewayFirewallLog'
])
param logsToEnable array = [
  'ApplicationGatewayAccessLog'
  'ApplicationGatewayPerformanceLog'
  'ApplicationGatewayFirewallLog'
]

@description('Optional. The name of metrics that will be streamed.')
@allowed([
  'AllMetrics'
])
param metricsToEnable array = [
  'AllMetrics'
]

var diagnosticsLogs = [for log in logsToEnable: {
  category: log
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var diagnosticsMetrics = [for metric in metricsToEnable: {
  category: metric
  timeGrain: null
  enabled: true
  retentionPolicy: {
    enabled: true
    days: diagnosticLogsRetentionInDays
  }
}]

var applicationGatewayResourceId = resourceId('Microsoft.Network/applicationGateways', name)
var subnetResourceId = empty(subnetId) ? resourceId(vNetSubscriptionId, vNetResourceGroup, 'Microsoft.Network/virtualNetworks/subnets', vNetName, subnetName) : subnetId
var frontendPublicIPConfigurationName = 'public'
var frontendPrivateIPConfigurationName = 'private'
var frontendPrivateIPDynamicConfiguration = {
  privateIPAllocationMethod: 'Dynamic'
  subnet: {
    id: subnetResourceId
  }
}
output frontendPrivateIPDynamicConfiguration object = frontendPrivateIPDynamicConfiguration
var frontendPrivateIPStaticConfiguration = {
  privateIPAllocationMethod: 'Static'
  privateIPAddress: frontendPrivateIpAddress
  subnet: {
    id: subnetResourceId
  }
}
output frontendPrivateIPStaticConfiguration object = frontendPrivateIPStaticConfiguration
var redirectConfigurationsHttpRedirectNamePrefix = 'httpRedirect'
var httpListenerhttpRedirectNamePrefix = 'httpRedirect'
var requestRoutingRuleHttpRedirectNamePrefix = 'httpRedirect'
var wafConfiguration = {
  enabled: true
  firewallMode: 'Detection'
  ruleSetType: 'OWASP'
  ruleSetVersion: '3.0'
  disabledRuleGroups: []
  requestBodyCheck: true
  maxRequestBodySizeInKb: '128'
}
var sslCertificates = [
  {
    name: sslCertificateName
    properties: {
      keyVaultSecretId: sslCertificateKeyVaultSecretId
    }
  }
]
output sslCertificates array = sslCertificates
var frontendPorts = union((empty(frontendHttpListeners) ? frontendHttpListeners : frontendHttpPorts), (empty(frontendHttpsListeners) ? frontendHttpsListeners : frontendHttpsPorts), (empty(frontendHttpRedirects) ? frontendHttpRedirects : frontendHttpRedirectPorts))
var httpListeners = concat((empty(frontendHttpListeners) ? frontendHttpListeners : frontendHttpListeners_var), (empty(frontendHttpsListeners) ? frontendHttpsListeners : frontendHttpsListeners_var), (empty(frontendHttpRedirects) ? frontendHttpRedirects : frontendHttpRedirects_var))
var redirectConfigurations = (empty(frontendHttpRedirects) ? frontendHttpRedirects : httpRedirectConfigurations)
var requestRoutingRules = concat(httpsRequestRoutingRules, (empty(frontendHttpRedirects) ? frontendHttpRedirects : httpRequestRoutingRules))

output frontendPorts array = frontendPorts
output httpListeners array = httpListeners
output redirectConfigurations array = redirectConfigurations
output requestRoutingRules array = requestRoutingRules


var identityType = !empty(userAssignedIdentities) ? 'UserAssigned' : 'None'

var identity = identityType != 'None' ? {
  type: identityType
  userAssignedIdentities: !empty(userAssignedIdentities) ? userAssignedIdentities : null
} : null
// output identity object = identity
var backendAddressPools = [for backendPool in backendPools: {
  name: backendPool.backendPoolName
  type: 'Microsoft.Network/applicationGateways/backendAddressPools'
  properties: {
    backendAddresses: contains(backendPool, 'BackendAddresses') ? backendPool.BackendAddresses : []
  }
}]
output backendAddressPools array = backendAddressPools
var probes_var = [for probe in probes: {
  name: '${probe.backendHttpConfigurationName}Probe'
  type: 'Microsoft.Network/applicationGateways/probes'
  properties: {
    protocol: probe.protocol
    host: probe.host
    path: probe.path
    interval: contains(probe, 'interval') ? probe.interval : 30
    timeout: contains(probe, 'timeout') ? probe.timeout : 30
    unhealthyThreshold: contains(probe, 'timeout') ? probe.unhealthyThreshold : 3
    minServers: contains(probe, 'timeout') ? probe.minServers : 0
    match: {
      body: contains(probe, 'timeout') ? probe.body : ''
      statusCodes: probe.statusCodes
    }
  }
}]
output probes_var array = probes_var
var backendHttpConfigurations_var = [for backendHttpConfiguration in backendHttpConfigurations: {
  name: backendHttpConfiguration.backendHttpConfigurationName
  properties: {
    port: backendHttpConfiguration.port
    protocol: backendHttpConfiguration.protocol
    cookieBasedAffinity: backendHttpConfiguration.cookieBasedAffinity
    pickHostNameFromBackendAddress: backendHttpConfiguration.pickHostNameFromBackendAddress
    probeEnabled: backendHttpConfiguration.probeEnabled
    probe: bool(backendHttpConfiguration.probeEnabled) ? json('{"id": "${applicationGatewayResourceId}/probes/${backendHttpConfiguration.backendHttpConfigurationName}Probe"}') : null
  }
}]
output backendHttpConfigurations_var array = backendHttpConfigurations_var
var frontendHttpsPorts = [for frontendHttpsListener in frontendHttpsListeners: {
  name: 'port${frontendHttpsListener.port}'
  properties: {
    Port: frontendHttpsListener.port
  }
}]
output frontendHttpsPorts array = frontendHttpsPorts
var frontendHttpsListeners_var = [for frontendHttpsListener in frontendHttpsListeners: {
  name: frontendHttpsListener.frontendListenerName
  properties: {
    FrontendIPConfiguration: {
      id: '${applicationGatewayResourceId}/frontendIPConfigurations/${frontendHttpsListener.frontendIPType}'
    }
    FrontendPort: {
      id: '${applicationGatewayResourceId}/frontendPorts/port${frontendHttpsListener.port}'
    }
    Protocol: 'https'
    SslCertificate: {
      id: '${applicationGatewayResourceId}/sslCertificates/${sslCertificateName}'
    }
  }
}]
output frontendHttpsListeners_var array = frontendHttpsListeners_var
var frontendHttpPorts = [for frontendHttpListener in frontendHttpListeners: {
  name: 'port${frontendHttpListener.port}'
  properties: {
    Port: frontendHttpListener.port
  }
}]
output frontendHttpPorts array = frontendHttpPorts
var frontendHttpListeners_var = [for frontendHttpListener in frontendHttpListeners: {
  name: frontendHttpListener.frontendListenerName
  properties: {
    FrontendIPConfiguration: {
      id: '${applicationGatewayResourceId}/frontendIPConfigurations/${frontendHttpListener.frontendIPType}'
    }
    FrontendPort: {
      id: '${applicationGatewayResourceId}/frontendPorts/port${frontendHttpListener.port}'
    }
    Protocol: 'http'
  }
}]
output frontendHttpListeners_var array = frontendHttpListeners_var
var httpsRequestRoutingRules = [for routingRule in routingRules: {
  name: '${routingRule.frontendListenerName}-${routingRule.backendHttpConfigurationName}-${routingRule.backendHttpConfigurationName}'
  properties: {
    RuleType: 'Basic'
    httpListener: {
      id: '${applicationGatewayResourceId}/httpListeners/${routingRule.frontendListenerName}'
    }
    backendAddressPool: {
      id: '${applicationGatewayResourceId}/backendAddressPools/${routingRule.backendPoolName}'
    }
    backendHttpSettings: {
      id: '${applicationGatewayResourceId}/backendHttpSettingsCollection/${routingRule.backendHttpConfigurationName}'
    }
  }
}]
output httpsRequestRoutingRules array = httpsRequestRoutingRules
var frontendHttpRedirectPorts = [for frontendHttpRedirect in frontendHttpRedirects: {
  name: 'port${frontendHttpRedirect.port}'
  properties: {
    Port: frontendHttpRedirect.port
  }
}]
output frontendHttpRedirectPorts array = frontendHttpRedirectPorts
var frontendHttpRedirects_var = [for frontendHttpRedirect in frontendHttpRedirects: {
  name: '${httpListenerhttpRedirectNamePrefix}${frontendHttpRedirect.port}'
  properties: {
    FrontendIPConfiguration: {
      id: '${applicationGatewayResourceId}/frontendIPConfigurations/${frontendHttpRedirect.frontendIPType}'
    }
    FrontendPort: {
      id: '${applicationGatewayResourceId}/frontendPorts/port${frontendHttpRedirect.port}'
    }
    Protocol: 'http'
  }
}]
output frontendHttpRedirects_var array = frontendHttpRedirects_var
var httpRequestRoutingRules = [for frontendHttpRedirect in frontendHttpRedirects: {
  name: '${requestRoutingRuleHttpRedirectNamePrefix}${frontendHttpRedirect.port}-${frontendHttpRedirect.frontendListenerName}'
  properties: {
    RuleType: 'Basic'
    httpListener: {
      id: '${applicationGatewayResourceId}/httpListeners/${httpListenerhttpRedirectNamePrefix}${frontendHttpRedirect.port}'
    }
    redirectConfiguration: {
      id: '${applicationGatewayResourceId}/redirectConfigurations/${redirectConfigurationsHttpRedirectNamePrefix}${frontendHttpRedirect.port}'
    }
  }
}]
output httpRequestRoutingRules array = httpRequestRoutingRules
var httpRedirectConfigurations = [for frontendHttpRedirect in frontendHttpRedirects: {
  name: '${redirectConfigurationsHttpRedirectNamePrefix}${frontendHttpRedirect.port}'
  properties: {
    redirectType: 'Permanent'
    includePath: true
    includeQueryString: true
    requestRoutingRules: [
      {
        id: '${applicationGatewayResourceId}/requestRoutingRules/${requestRoutingRuleHttpRedirectNamePrefix}${frontendHttpRedirect.port}-${frontendHttpRedirect.frontendListenerName}'
      }
    ]
    targetListener: {
      id: '${applicationGatewayResourceId}/httpListeners/${frontendHttpRedirect.frontendListenerName}'
    }
  }
}]
output httpRedirectConfigurations array = httpRedirectConfigurations

resource applicationGateway 'Microsoft.Network/applicationGateways@2021-03-01' = {
  name: name
  location: location
  identity: identity
  tags: tags
  properties: {
    sku: {
      name: sku
      tier: endsWith(sku, 'v2') ? sku : substring(sku, 0, indexOf(sku, '_'))
      capacity: capacity
    }
    gatewayIPConfigurations: [
      {
        name: gatewayIpConfigurationName
        properties: {
          subnet: {
            id: subnetResourceId
          }
        }
      }
    ]
    frontendIPConfigurations: [
      {
        name: frontendPrivateIPConfigurationName
        type: 'Microsoft.Network/applicationGateways/frontendIPConfigurations'
        properties: empty(frontendPrivateIpAddress) ? frontendPrivateIPDynamicConfiguration : frontendPrivateIPStaticConfiguration
      }
      {
        name: frontendPublicIPConfigurationName
        properties: {
          publicIPAddress: {
            id: frontendPublicIpResourceId
          }
        }
      }
    ]
    sslCertificates: empty(sslCertificateKeyVaultSecretId) ? null : sslCertificates
    backendAddressPools: backendAddressPools
    probes: probes_var
    backendHttpSettingsCollection: backendHttpConfigurations_var
    frontendPorts: frontendPorts
    httpListeners: httpListeners
    redirectConfigurations: redirectConfigurations
    requestRoutingRules: requestRoutingRules
    enableHttp2: http2Enabled
    firewallPolicy: {
      id: firewallPolicyId //'/subscriptions/167823da-0f70-4b25-992f-f29fdd28d520/resourceGroups/rg-azusw2-dvo-dv1-appgateway/providers/Microsoft.Network/ApplicationGatewayWebApplicationFirewallPolicies/waf-azusw2-dvo-dv1-WAFappgateway'
    }
  }
  dependsOn: []
}

resource applicationGateway_lock 'Microsoft.Authorization/locks@2016-09-01' = if (lock != 'NotSpecified') {
  name: '${applicationGateway.name}-${lock}-lock'
  properties: {
    level: lock
    notes: lock == 'CanNotDelete' ? 'Cannot delete resource or child resources.' : 'Cannot modify the resource or child resources.'
  }
  scope: applicationGateway
}

resource applicationGateway_diagnosticSettingName 'Microsoft.Insights/diagnosticSettings@2021-05-01-preview' = if (!empty(diagnosticStorageAccountId) || !empty(workspaceId) || !empty(eventHubAuthorizationRuleId) || !empty(eventHubName)) {
  name: '${applicationGateway.name}-diagnosticSettings'
  properties: {
    storageAccountId: empty(diagnosticStorageAccountId) ? null : diagnosticStorageAccountId
    workspaceId: empty(workspaceId) ? null : workspaceId
    eventHubAuthorizationRuleId: empty(eventHubAuthorizationRuleId) ? null : eventHubAuthorizationRuleId
    eventHubName: empty(eventHubName) ? null : eventHubName
    metrics: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsMetrics
    logs: empty(diagnosticStorageAccountId) && empty(workspaceId) && empty(eventHubAuthorizationRuleId) && empty(eventHubName) ? null : diagnosticsLogs
  }
  scope: applicationGateway
}


@description('The name of the application gateway')
output applicationGatewayName string = applicationGateway.name

@description('The resource ID of the application gateway')
output applicationGatewayResourceId string = applicationGateway.id

@description('The resource group the application gateway was deployed into')
output applicationGatewayResourceGroup string = resourceGroup().name
