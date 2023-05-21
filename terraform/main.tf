# Set these up in terraform.tfvars or add env variables as described in README
variable "user_name" {}
variable "tenant_name" {}
variable "tenant_id" {}
variable "user_domain_name" {}
variable "password" {}
variable "auth_url" {}
variable "region" {}
variable "user_keyPair" {}
variable "default_sg_id" {}
variable "public_network_id" {}

# These are already defined in terraform.tfvars. You can change them if you want
variable "mysql_root_password" {}
variable "mysql_user" {}
variable "mysql_user_password" {}
variable "mysql_database" {}

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

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_ssh" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 22
  port_range_max    = 22
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_sg_id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_custom_port_3000" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3000
  port_range_max    = 3000
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_sg_id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_custom_port_8080" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 8080
  port_range_max    = 8080
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_sg_id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_custom_port_9100" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9100
  port_range_max    = 9100
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_sg_id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_custom_port_9090" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 9090
  port_range_max    = 9090
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_sg_id
}

resource "openstack_networking_secgroup_rule_v2" "secgroup_rule_custom_port_3457" {
  direction         = "ingress"
  ethertype         = "IPv4"
  protocol          = "tcp"
  port_range_min    = 3457
  port_range_max    = 3457
  remote_ip_prefix  = "0.0.0.0/0"
  security_group_id = var.default_sg_id
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
    start = "192.168.0.112"
    end   = "192.168.0.250"
  }

  dns_nameservers = ["8.8.8.8", "1.1.1.1"]
}

resource "openstack_networking_router_v2" "router" {
  name                = "router"
  admin_state_up      = "true"
  external_network_id = "${var.public_network_id}"
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

  security_groups = ["default"]

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

  security_groups = ["default"]

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

  security_groups = ["default"]

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

resource "null_resource" "install-components" {
  depends_on = [
      null_resource.jumpmachine_provisioning,
      null_resource.install_ansible
    ]

    provisioner "local-exec" {
    environment = {
      ANSIBLE_HOST_KEY_CHECKING = "False"
    }
    command = <<-EOT
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no install-components.yml ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/install-components.yml
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no inventory.ini ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/inventory.ini
      ssh -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address} 'ANSIBLE_SSH_ARGS="-o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no" ansible-playbook -i /home/ubuntu/inventory.ini --limit instances /home/ubuntu/install-components.yml -e "mysql_root_password=${var.mysql_root_password} mysql_user=${var.mysql_user} mysql_user_password=${var.mysql_user_password} mysql_database=${var.mysql_database}"'
    EOT
  }
}

resource "null_resource" "deploy_frontend" {
  depends_on = [
    openstack_compute_instance_v2.jumpmachine,
    null_resource.jumpmachine_provisioning,
    null_resource.install-components
    ]
  
  provisioner "local-exec" {
    command = "rsync -e 'ssh -i ${var.user_keyPair}.pem -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null' -az --exclude-from='${path.module}/../frontend/.gitignore' ${path.module}/../frontend/ ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/frontend/"
  }

  provisioner "file" {
    content = templatefile(
      "env.template",
      {
        backend_url = format(
          "http://cscloud%s-%s.lnu.se:8080/api/v1",
          substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
          element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
        )
      }
    )
    destination = "/home/ubuntu/frontend/.env"

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.floatingip_1.address
      user        = "ubuntu"
      private_key = file("${var.user_keyPair}.pem")
    }
  }

  provisioner "remote-exec" {
    inline = [
      "cd /home/ubuntu/frontend",
      "docker build -t prasannjeet/notenirvana-front:dev-SNAPSHOT-Jump -f docker/Dockerfile .",
      "docker run -d -p 3000:3000 prasannjeet/notenirvana-front:dev-SNAPSHOT-Jump"
    ]

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.floatingip_1.address
      user        = "ubuntu"
      private_key = file("${var.user_keyPair}.pem")
    }
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

output "rendered_template_env" {
  value = templatefile("backend_template.tpl", {
    DB_HOST           = openstack_compute_instance_v2.database.network.0.fixed_ip_v4
    DB_PORT           = "3306"
    DB_NAME           = var.mysql_database
    DB_USER           = var.mysql_user
    DB_PASSWORD       = var.mysql_user_password
    ALLOWED_ORIGINS   = "http://${openstack_networking_floatingip_v2.floatingip_1.address}:3000,http://${openstack_networking_floatingip_v2.floatingip_1.address}:3000/"
    ALLOWED_ORIGINS_EXT = format(
      "http://cscloud%s-%s.lnu.se:3000,http://cscloud%s-%s.lnu.se/",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3),
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )
  })
}

resource "null_resource" "deploy_backend" {
  depends_on = [
    null_resource.jumpmachine_provisioning,
    null_resource.install-components
  ]

  provisioner "local-exec" {
    command = <<-EOT
      rendered_template_env=$(terraform output -raw rendered_template_env)
      echo "$rendered_template_env" > backend_template.env
      ssh -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address} 'mkdir -p /home/ubuntu/backend'
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no backend_template.env ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/backend/template.env
      ssh -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address} 'docker run -d --name my-notenirvana -p 8080:8080 --env-file /home/ubuntu/backend/template.env prasannjeet/notenirvana:dev-SNAPSHOT'
    EOT
  }
}

resource "local_file" "endpoints" {
  filename = "endpoints.txt"
  content = <<-EOF
    frontend-url: ${format(
      "http://cscloud%s-%s.lnu.se:3000",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}
    backend-url: ${format(
      "http://cscloud%s-%s.lnu.se:8080/api/swagger-ui/index.html#/",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}
    keycloak-url: https://keycloak.ooguy.com
    node-exporter-url: ${format(
      "http://cscloud%s-%s.lnu.se:9100/metrics",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}
    prometheus-url: ${format(
      "http://cscloud%s-%s.lnu.se:9090",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}
    grafana-url: ${format(
      "http://cscloud%s-%s.lnu.se:3457/login",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}
  EOF
}

resource "null_resource" "update_keycloak_client" {
  triggers = {
    floating_ip = openstack_networking_floatingip_v2.floatingip_1.address
  }

  provisioner "local-exec" {
    command = "bash add-keycloak-cors.sh ${format(
      "http://cscloud%s-%s.lnu.se:3000",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}"
  }

  provisioner "local-exec" {
    command = "bash add-keycloak-cors.sh ${format(
      "http://cscloud%s-%s.lnu.se:3000/*",
      substr(element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 2), -1, 1),
      element(split(".", openstack_networking_floatingip_v2.floatingip_1.address), 3)
    )}"
  }
}

resource "null_resource" "install_monitoring_jumpmachine" {
  depends_on = [
    null_resource.install-components
  ]

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address} 'mkdir /home/ubuntu/monitor && mkdir /home/ubuntu/monitor/datasources && mkdir /home/ubuntu/monitor/dashboards'
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no grafana/docker-compose.yml ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/monitor/docker-compose.yml
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no grafana/dashboards.yaml ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/monitor/dashboards/dashboards.yaml
      scp -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no grafana/dashboard*.json ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address}:/home/ubuntu/monitor/dashboards/
    EOT
  }

  provisioner "file" {
    content = templatefile(
      "grafana/datasources.template",
      {
        local_ip = element(openstack_networking_port_v2.port_1.all_fixed_ips, 0),
        db_ip = element(openstack_networking_port_v2.port_3.all_fixed_ips, 0)
      }
    )
    destination = "/home/ubuntu/monitor/datasources/datasources.yml"

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.floatingip_1.address
      user        = "ubuntu"
      private_key = file("${var.user_keyPair}.pem")
    }
  }

  provisioner "file" {
    content = templatefile(
      "grafana/prometheus.template",
      {
        local_ip = element(openstack_networking_port_v2.port_1.all_fixed_ips, 0),
        ws_ip = element(openstack_networking_port_v2.port_2.all_fixed_ips, 0),
        db_ip = element(openstack_networking_port_v2.port_3.all_fixed_ips, 0)
      }
    )
    destination = "/home/ubuntu/monitor/prometheus.yml"

    connection {
      type        = "ssh"
      host        = openstack_networking_floatingip_v2.floatingip_1.address
      user        = "ubuntu"
      private_key = file("${var.user_keyPair}.pem")
    }
  }

  provisioner "local-exec" {
    command = <<-EOT
      ssh -i ${var.user_keyPair}.pem -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no ubuntu@${openstack_networking_floatingip_v2.floatingip_1.address} 'cd /home/ubuntu/monitor && docker-compose up -d'
    EOT
  }

}
