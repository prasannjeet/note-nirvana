# Terraform OpenStack Cluster Deployment

This document describes a Terraform file that provisions an OpenStack cluster with multiple instances, networks, and other resources. Before diving into the specifics of the Terraform file, let's briefly define Terraform and OpenStack.

## Terraform

Terraform is an open-source Infrastructure as Code (IaC) tool that allows you to provision, manage, and maintain cloud infrastructure resources in a declarative way. It supports multiple cloud providers, including OpenStack.

## OpenStack

OpenStack is an open-source cloud computing platform used to build public and private clouds. It offers various services for managing compute, storage, and networking resources.

## Terraform File Overview

The Terraform file creates an OpenStack cluster with the following resources:

-   3 instances with different configurations
-   1 network
-   1 subnet
-   1 router
-   3 security groups with associated rules
-   3 networking ports
-   3 block storage volumes attached to instances
-   3 floating IPs associated with instances

### Terraform and OpenStack Provider Configuration

The Terraform file starts with configuring the required OpenStack provider and defining the provider settings.

```
terraform {
  required_providers {
    openstack = {
      source = "terraform-provider-openstack/openstack"
    }
  }
}

provider "openstack" {
  auth_url     = var.OS_AUTH_URL
  user_name    = var.OS_USERNAME
  password     = var.OS_PASSWORD
  tenant_name  = var.OS_PROJECT_NAME
}
```
#### Terraform Configuration Block

The `terraform` block declares the required provider for this configuration, specifying the OpenStack provider's source.

#### OpenStack Provider Block

The `provider` block configures the OpenStack provider, including authentication details such as `auth_url`, `user_name`, `password`, and `tenant_name`. These values are passed as variables to the configuration file.

### Network Resources

The Terraform file sets up a network, subnet, router, and router interface.

```
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  network_id = openstack_networking_network_v2.network_1.id
  cidr       = "192.168.0.0/24"
  ip_version = 4

  gateway_ip       = "192.168.0.1"
  enable_dhcp      = "true"
  allocation_pool  {
    start = "192.168.0.100"
    end   = "192.168.0.250"
  }

  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}

resource "openstack_networking_router_v2" "router_1" {
  name                = "router_1"
  admin_state_up      = "true"
  external_network_id = var.PUBLIC_NETWORK_UUID
}

resource "openstack_networking_router_interface_v2" "router_gateway_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}
```

### Network Resource
The `openstack_networking_network_v2` resource creates a network named `network_1`.

```
resource "openstack_networking_network_v2" "network_1" {
  name           = "network_1"
  admin_state_up = "true"
}
```
### Subnet Resource

The `openstack_networking_subnet_v2` resource creates a subnet named `subnet_1` with a CIDR of `192.168.0.0/24`. It associates the subnet with the previously created network `network_1`.
```
resource "openstack_networking_subnet_v2" "subnet_1" {
  name       = "subnet_1"
  cidr       = "192.168.0.0/24"
  network_id = openstack_networking_network_v2.network_1.id

  dns_nameservers = ["8.8.8.8", "8.8.4.4"]

  allocation_pools {
    start = "192.168.0.100"
    end   = "192.168.0.200"
  }
}
```
In this configuration, the `dns_nameservers` attribute is used to specify the DNS servers for the subnet, and the `allocation_pools` block is used to define the range of IP addresses available for allocation within the subnet.

### OpenStack Compute Volume Attach

The `openstack_compute_volume_attach_v2` resources are used to attach the previously created block storage volumes to the respective instances.
```
resource "openstack_compute_volume_attach_v2" "attach_1" {
  instance_id = openstack_compute_instance_v2.instance_1.id
  volume_id   = openstack_blockstorage_volume_v3.volume_1.id
}

resource "openstack_compute_volume_attach_v2" "attach_2" {
  instance_id = openstack_compute_instance_v2.instance_2.id
  volume_id   = openstack_blockstorage_volume_v3.volume_2.id
}

resource "openstack_compute_volume_attach_v2" "attach_3" {
  instance_id = openstack_compute_instance_v2.instance_3.id
  volume_id   = openstack_blockstorage_volume_v3.volume_3.id
}
```
### OpenStack Networking Floating IPs

The `openstack_networking_floatingip_v2` resources are used to create floating IPs from the public network pool. These floating IPs will be associated with the instances to enable external access.
```
resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = var.PUBLIC_NETWORK_NAME # Replace with the name of the "public" network
}

resource "openstack_networking_floatingip_v2" "floatingip_2" {
  pool = var.PUBLIC_NETWORK_NAME # Replace with the name of the "public" network
}

resource "openstack_networking_floatingip_v2" "floatingip_3" {
  pool = var.PUBLIC_NETWORK_NAME # Replace with the name of the "public" network
}
```
### OpenStack Compute Floating IP Association

The `openstack_compute_floatingip_associate_v2` resources are used to associate the previously created floating IPs with the respective instances.
```
resource "openstack_compute_floatingip_associate_v2" "associate_floatingip_1" {
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
  instance_id = openstack_compute_instance_v2.instance_1.id
}

resource "openstack_compute_floatingip_associate_v2" "associate_floatingip_2" {
  floating_ip = openstack_networking_floatingip_v2.floatingip_2.address
  instance_id = openstack_compute_instance_v2.instance_2.id
}

resource "openstack_compute_floatingip_associate_v2" "associate_floatingip_3" {
  floating_ip = openstack_networking_floatingip_v2.floatingip_3.address
  instance_id = openstack_compute_instance_v2.instance_3.id
}
```

## Executing Shell Script
After the stacks are deployed, a shell script with the name `userdata-master.tpl` and `userdata-worker.tpl` is also run on respective instances which does basic installations on the server. It updates the sources repository and updates any entities that could be updated. Furthermore it also installs other tools such as `docker` in the system.

---
In summary, this Terraform file sets up an OpenStack environment with a private network, router, instances, security groups, block storage volumes, and floating IPs. It also configures the necessary resources to enable external access to the instances via the floating IPs.