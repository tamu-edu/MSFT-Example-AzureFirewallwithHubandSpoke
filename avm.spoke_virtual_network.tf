module "spoke_virtual_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.16.0"

  name          = local.resource_names.spoke_virtual_network_name
  location      = var.location
  address_space = [var.spoke_address_space]
  parent_id     = module.resource_group.resource_id

  subnets = {
    workload = {
      name             = "snet-workload"
      address_prefixes = [var.spoke_workload_subnet_address_prefix]
      route_table = {
        id = azurerm_route_table.spoke.id
      }
    }
  }

  peerings = {
    spoke-to-hub = {
      name                                 = "peer-spoke-to-hub"
      remote_virtual_network_resource_id   = module.virtual_network.resource_id
      allow_forwarded_traffic              = true
      allow_virtual_network_access         = true
      allow_gateway_transit                = false
      use_remote_gateways                  = false
      create_reverse_peering               = true
      reverse_name                         = "peer-hub-to-spoke"
      reverse_allow_forwarded_traffic      = true
      reverse_allow_gateway_transit        = true
      reverse_allow_virtual_network_access = true
      reverse_use_remote_gateways          = false
    }
  }

  tags = var.tags
}
