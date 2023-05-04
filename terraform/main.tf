# Define required providers
terraform {
required_version = ">= 0.14.0"
  required_providers {
    openstack = {
      source  = "terraform-provider-openstack/openstack"
      version = "~> 1.48.0"
    }
  }
}

provider "openstack" {
  auth_url     = var.OS_AUTH_URL
  user_name    = var.OS_USERNAME
  password     = var.OS_PASSWORD
  tenant_name  = var.OS_PROJECT_NAME
}

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
  external_network_id = var.PUBLIC_NETWORK_UUID # Replace with the UUID of the "public" network
}

resource "openstack_networking_router_interface_v2" "router_gateway_1" {
  router_id = openstack_networking_router_v2.router_1.id
  subnet_id = openstack_networking_subnet_v2.subnet_1.id
}

resource "openstack_compute_secgroup_v2" "secgroup_1" {
  name        = "secgroup_1"
  description = "Secgroup allowing required ports"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_1.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_1_tcp_10000" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10000
  port_range_max    = 10000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_1.id
}


resource "openstack_compute_secgroup_v2" "secgroup_2" {
  name        = "secgroup_2"
  description = "Secgroup allowing required ports"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_2_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_2.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_2_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_2.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_2_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_2.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_2_tcp_10000" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10000
  port_range_max    = 10000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_2.id
}

resource "openstack_compute_secgroup_v2" "secgroup_3" {
  name        = "secgroup_3"
  description = "Secgroup allowing required ports"
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_3_http" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 80
  port_range_max    = 80
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_3.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_3_https" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 443
  port_range_max    = 443
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_3.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_3_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_3.id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_3_tcp_10000" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 10000
  port_range_max    = 10000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = openstack_compute_secgroup_v2.secgroup_3.id
}

resource "openstack_networking_port_v2" "port_1" {
  name           = "port_1"
  network_id     = openstack_networking_network_v2.network_1.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_networking_port_v2" "port_2" {
  name           = "port_2"
  network_id     = openstack_networking_network_v2.network_1.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_networking_port_v2" "port_3" {
  name           = "port_3"
  network_id     = openstack_networking_network_v2.network_1.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet_1.id
  }
}

resource "openstack_compute_instance_v2" "instance_1" {
  name            = "instance_1"
  security_groups = [openstack_compute_secgroup_v2.secgroup_1.name]
  key_pair        = "ps222vt_Keypair"

  flavor_name = "c4-r8-d80"
  image_id = "f73ec00b-6ea9-456b-a182-736b53e78e06"

  network {
    uuid = openstack_networking_network_v2.network_1.id
    port = openstack_networking_port_v2.port_1.id
  }

  metadata = {
    role = "master"
  }

  availability_zone = "Education"
  user_data = filebase64("${path.module}/userdata-master.tpl")
}

resource "openstack_compute_instance_v2" "instance_2" {
  name            = "instance_2"
  security_groups = [openstack_compute_secgroup_v2.secgroup_2.name]
  key_pair        = "ps222vt_Keypair"

  flavor_name = "c4-r16-d80"
  image_id = "f73ec00b-6ea9-456b-a182-736b53e78e06"

  network {
    uuid = openstack_networking_network_v2.network_1.id
    port = openstack_networking_port_v2.port_2.id
  }

  metadata = {
    role = "worker"
  }

  availability_zone = "Education"
  user_data = filebase64("${path.module}/userdata-worker.tpl")
}

resource "openstack_compute_instance_v2" "instance_3" {
  name            = "instance_3"
  security_groups = [openstack_compute_secgroup_v2.secgroup_3.name]
  key_pair        = "ps222vt_Keypair"

  flavor_name = "c4-r16-d80"
  image_id = "f73ec00b-6ea9-456b-a182-736b53e78e06"

  network {
    uuid = openstack_networking_network_v2.network_1.id
    port = openstack_networking_port_v2.port_3.id
  }

  metadata = {
    role = "worker"
  }

  availability_zone = "Education"
  user_data = filebase64("${path.module}/userdata-worker.tpl")
}


resource "openstack_blockstorage_volume_v3" "volume_1" {
  name = "volume_1"
  size = 20
}

resource "openstack_compute_volume_attach_v2" "attach_1" {
  instance_id = openstack_compute_instance_v2.instance_1.id
  volume_id   = openstack_blockstorage_volume_v3.volume_1.id
}

resource "openstack_blockstorage_volume_v3" "volume_2" {
  name = "volume_2"
  size = 10
}

resource "openstack_compute_volume_attach_v2" "attach_2" {
  instance_id = openstack_compute_instance_v2.instance_2.id
  volume_id   = openstack_blockstorage_volume_v3.volume_2.id
}

resource "openstack_blockstorage_volume_v3" "volume_3" {
  name = "volume_3"
  size = 10
}

resource "openstack_compute_volume_attach_v2" "attach_3" {
  instance_id = openstack_compute_instance_v2.instance_3.id
  volume_id   = openstack_blockstorage_volume_v3.volume_3.id
}

resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = var.PUBLIC_NETWORK_NAME # Replace with the name of the "public" network
}

resource "openstack_networking_floatingip_v2" "floatingip_2" {
  pool = var.PUBLIC_NETWORK_NAME # Replace with the name of the "public" network
}

resource "openstack_networking_floatingip_v2" "floatingip_3" {
  pool = var.PUBLIC_NETWORK_NAME # Replace with the name of the "public" network
}

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