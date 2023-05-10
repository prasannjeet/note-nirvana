variable "user_name" {}
variable "tenant_name" {}
variable "tenant_id" {}
variable "user_domain_name" {}
variable "password" {}
variable "auth_url" {}
variable "region" {}
variable "user_keyPair" {}

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

# Configure the OpenStack Provider
provider "openstack" {
  user_name         = "${var.user_name}"
  tenant_name       = "${var.tenant_name}"
  tenant_id         = "${var.tenant_id}"
  user_domain_name  = "${var.user_domain_name}"
  password          = "${var.password}"
  auth_url          = "${var.auth_url}"
  region            = "${var.region}"
}


# Create a security group for SSH access
resource "openstack_compute_secgroup_v2" "ssh" {
  name        = "ssh"
  description = "ssh"

  rule {
    from_port   = 22
    to_port     = 22
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }
}


# Create a security group for http
resource "openstack_compute_secgroup_v2" "http" {
    name        = "http"
    description = "http"

    rule {
        from_port   = 81
        to_port     = 81
        ip_protocol = "tcp"
        cidr        = "0.0.0.0/0"
    }
  
}

# Create a security group for https
resource "openstack_compute_secgroup_v2" "https" {
    name        = "https"
    description = "htps"

    rule {
        from_port   = 443
        to_port     = 443
        ip_protocol = "tcp"
        cidr        = "0.0.0.0/0"
    }
}

# Create a security group for tcp
resource "openstack_compute_secgroup_v2" "tcp" {
    name        = "tcp"
    description = "tcp"

   rule {
    from_port   = 80
    to_port     = 80
    ip_protocol = "tcp"
    cidr        = "0.0.0.0/0"
  }

}

resource "openstack_networking_network_v2" "network" {
  name           = "network"
  admin_state_up = "true"
}

resource "openstack_networking_subnet_v2" "subnet" {
  name       = "subnet"
  network_id = openstack_networking_network_v2.network.id
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

resource "openstack_networking_router_v2" "router" {
  name                = "router"
  admin_state_up      = "true"
  external_network_id = "fd401e50-9484-4883-9672-a2814089528c" # Replace with the UUID of the "public" network
}

resource "openstack_networking_port_v2" "port_1" {
  name           = "port_1"
  network_id     = openstack_networking_network_v2.network.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
  }
}

resource "openstack_networking_port_v2" "port_2" {
  name           = "port_2"
  network_id     = openstack_networking_network_v2.network.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
  }
}

resource "openstack_networking_port_v2" "port_3" {
  name           = "port_3"
  network_id     = openstack_networking_network_v2.network.id
  admin_state_up = "true"

  fixed_ip {
    subnet_id = openstack_networking_subnet_v2.subnet.id
  }
}

resource "openstack_networking_router_interface_v2" "router_gateway_1" {
  router_id = openstack_networking_router_v2.router.id
  subnet_id = openstack_networking_subnet_v2.subnet.id
}

# Create the jump server
resource "openstack_compute_instance_v2" "jumpmachine" {
  name            = "jumpmachine"
  flavor_name     = "c4-r8-d80"
  image_id        = "f73ec00b-6ea9-456b-a182-736b53e78e06"
  key_pair        = "${var.user_keyPair}"
  security_groups = ["default", openstack_compute_secgroup_v2.ssh.name, openstack_compute_secgroup_v2.http.name, openstack_compute_secgroup_v2.https.name, openstack_compute_secgroup_v2.tcp.name]

  network {
    name = "network"
    port = openstack_networking_port_v2.port_1.id
  }

  availability_zone = "Education"
}


resource "openstack_compute_instance_v2" "webserver" {
  name            = "webserver"
  flavor_name     = "c4-r8-d80"
  image_id        = "f73ec00b-6ea9-456b-a182-736b53e78e06"
  key_pair        = "${var.user_keyPair}"
  security_groups = ["default",openstack_compute_secgroup_v2.ssh.name,openstack_compute_secgroup_v2.http.name, openstack_compute_secgroup_v2.https.name, openstack_compute_secgroup_v2.tcp.name]
network {
    name = "network"
    port = openstack_networking_port_v2.port_2.id
    
  }

  availability_zone = "Education"
}

# Create the web server
resource "openstack_compute_instance_v2" "database" {
  name            = "database"
  flavor_name     = "c4-r8-d80"
  image_id        = "f73ec00b-6ea9-456b-a182-736b53e78e06"
  key_pair        = "${var.user_keyPair}"
  security_groups = ["default",openstack_compute_secgroup_v2.ssh.name,openstack_compute_secgroup_v2.http.name, openstack_compute_secgroup_v2.https.name, openstack_compute_secgroup_v2.tcp.name]
  network {
    name = "network"
    port = openstack_networking_port_v2.port_3.id
  }


  availability_zone = "Education"
}

resource "openstack_networking_floatingip_v2" "floatingip_1" {
  pool = "public" # Replace with the name of the "public" network
}

resource "openstack_compute_floatingip_associate_v2" "associate_floatingip_1" {
  floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
  instance_id = openstack_compute_instance_v2.jumpmachine.id
  depends_on  = [openstack_compute_instance_v2.jumpmachine]
}

# Save IP Addresses into file
resource "null_resource" "save_ips" {
  depends_on = [
    openstack_compute_instance_v2.jumpmachine,
    openstack_compute_instance_v2.webserver,
    openstack_compute_instance_v2.database,
    openstack_networking_floatingip_v2.floatingip_1
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "jumpmachine ${element(openstack_networking_port_v2.port_1.all_fixed_ips, 0)}" > local_ips.txt
      echo "webserver ${element(openstack_networking_port_v2.port_2.all_fixed_ips, 0)}" >> local_ips.txt
      echo "database ${element(openstack_networking_port_v2.port_3.all_fixed_ips, 0)}" >> local_ips.txt
      echo "${openstack_networking_floatingip_v2.floatingip_1.address}" > floating_ip.txt
    EOT
  }

  # Add the script as a provisioner
  provisioner "local-exec" {
    command = "bash generate_ansible_files.sh"
  }
}

resource "null_resource" "jumpmachine_provisioning" {
  triggers = {
    jumpmachine_id = openstack_compute_instance_v2.jumpmachine.id
  }

  depends_on = [
    openstack_compute_floatingip_associate_v2.associate_floatingip_1
  ]

  provisioner "file" {
    source      = "${var.user_keyPair}.pem"
    destination = "/home/ubuntu/.ssh/${var.user_keyPair}.pem"

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.floatingip_1.address
      user        = "ubuntu"
      private_key = file("${var.user_keyPair}.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "chmod 600 /home/ubuntu/.ssh/${var.user_keyPair}.pem"
    ]

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.floatingip_1.address
      user        = "ubuntu"
      private_key = file("${var.user_keyPair}.pem")
    }
  }
}

resource "null_resource" "install_ansible" {
  depends_on = [
    openstack_compute_instance_v2.jumpmachine,
    null_resource.jumpmachine_provisioning
    ]

  provisioner "local-exec" {
    command = <<-EOT
      ansible-playbook -i inventory.ini --limit jumpmachine_group install_ansible.yml
    EOT
  }
}

resource "null_resource" "install_docker" {
  depends_on = [
      null_resource.jumpmachine_provisioning,
      null_resource.install_ansible
    ]

    provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<-EOT
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no install-docker.yml ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/install-docker.yml
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no inventory.ini ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/inventory.ini
      ssh -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address} 'ANSIBLE_SSH_ARGS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/inventory.ini --limit instances /home/ubuntu/install-docker.yml'
    EOT
  }
}

resource "null_resource" "create_inventory" {
  depends_on = [
    openstack_compute_instance_v2.jumpmachine,
    openstack_compute_instance_v2.webserver,
    openstack_compute_instance_v2.database
  ]

  provisioner "local-exec" {
    command = <<-EOT
      echo "[jumpmachine]" > inventory.ini
      echo "jumpmachine ansible_host=${openstack_networking_floatingip_v2.floatingip_1.address}" >> inventory.ini
      echo "" >> inventory.ini
      echo "[all_instances]" >> inventory.ini
      echo "jumpmachine ansible_host=${element(openstack_networking_port_v2.port_1.all_fixed_ips, 0)}" >> inventory.ini
      echo "webserver ansible_host=${element(openstack_networking_port_v2.port_2.all_fixed_ips, 0)}" >> inventory.ini
      echo "database ansible_host=${element(openstack_networking_port_v2.port_3.all_fixed_ips, 0)}" >> inventory.ini
    EOT
  }
}
