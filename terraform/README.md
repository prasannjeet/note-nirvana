# Terraform OpenStack Infrastructure

This repository contains Terraform configuration files to provision a custom infrastructure on OpenStack. It deploys a jump server, a web server, and a database server, each with specific security groups for SSH, HTTP, HTTPS, and TCP access.

## What is Terraform?

Terraform is an open-source infrastructure as code (IaC) software tool that allows you to define and provide data center infrastructure using a declarative configuration language. Terraform is cloud-agnostic and supports multiple providers such as AWS, Azure, Google Cloud, and OpenStack.

## Prerequisites

To get started, you'll need the following installed:

-   [Terraform](https://www.terraform.io/downloads.html)
-   [OpenStack CLI](https://docs.openstack.org/newton/user-guide/common/cli-install-openstack-command-line-clients.html)

## Configuration

1.  Clone the repository:
    
	```
	git clone <repository-url>
	cd <repository-folder>
	```
    
2.  Install the required Terraform providers:
    
	```
	terraform init
	```
    
3.  Set environment variables for your Terraform configuration. Make sure to replace `<pssword>`, etc. with your actual password, etc:

	```
	export TF_VAR_user_name="<username>"
	export TF_VAR_tenant_name="<tenant-name>"
	export TF_VAR_tenant_id="<tenant-id>"
	export TF_VAR_user_domain_name="Default"
	export TF_VAR_password="<pssword>"
	export TF_VAR_auth_url="https://cscloud.lnu.se:5000/v3"
	export TF_VAR_region="RegionOne"
	export TF_VAR_user_keyPiar="<key-pair-name>"
	```
    
For the `your_key_ssh.pem` file, you can read the file content and set it as an environment variable by running the following command:
    
```
export TF_VAR_ssh_key_private="$(cat ~/.ssh/location/of/key/file.pem)"
```

## Deploy the Infrastructure

1.  Verify the Terraform plan:
    
```
terraform plan
```
    
2.  Apply the Terraform configuration:
    
```
terraform apply
```
    
3.  After the infrastructure is deployed, you can use `terraform output` to display the floating IP address of the jump server:
    
```
terraform output
```

## Infrastructure Overview

-   **Security Groups:**
    
    -   SSH: Allows SSH access (port 22)
    -   HTTP: Allows HTTP access (port 81)
    -   HTTPS: Allows HTTPS access (port 443)
    -   TCP: Allows TCP access (port 80)
-   **Network Components:**
    
    -   Network
    -   Subnet
    -   Router
    -   Ports for each server
-   **Servers:**
    
    -   Jump Server: A jump server with SSH, HTTP, HTTPS, and TCP access
    -   Web Server: A web server with SSH, HTTP, HTTPS, and TCP access
    -   Database Server: A database server with SSH, HTTP, HTTPS, and TCP access
-   **Floating IP:**
    
    -   A floating IP is associated with the jump server for external access

## Clean Up

To destroy the infrastructure and clean up the resources:

```
terraform destroy
```

_Note: Make sure to destroy the resources after use to avoid unnecessary costs._

---
# Terraform Infrastructure Setup

This Terraform setup creates a network infrastructure on OpenStack, which includes creating security groups, a private network, a subnet, a router, and three instances: a jump server, a web server, and a database server. The instances are associated with the required security groups, and a floating IP is assigned to the jump server. When the settings are applied, the code also saves the local ip addresses of each of the machines and the floating ip address of the jump machine to a text file.

## Prerequisites

- Terraform v0.14.0 or higher
- OpenStack provider v1.48.0 or higher

## Variables

The following variables are required:

- `user_name`
- `tenant_name`
- `tenant_id`
- `user_domain_name`
- `password`
- `auth_url`
- `region`
- `user_keyPiar`

## Security Groups

There are four security groups created in this setup:

1. `ssh` - Allows SSH access (port 22) from any IP address
2. `http` - Allows HTTP access (port 81) from any IP address
3. `https` - Allows HTTPS access (port 443) from any IP address
4. `tcp` - Allows TCP access (port 80) from any IP address

## Network

A private network (`network`) and a subnet (`subnet`) are created. The subnet uses CIDR `192.168.0.0/24`, has a gateway at `192.168.0.1`, and enables DHCP with an allocation pool ranging from `192.168.0.100` to `192.168.0.250`. The DNS name servers are set to `8.8.8.8` and `1.1.1.1`.

## Router

A router (`router`) is created and connected to the "public" network (replace `external_network_id` with the UUID of your "public" network). It is also connected to the subnet created earlier.

## Instances

Three instances are created:

1. `jumpmachine` - A jump server, connected to `port_1`
2. `webserver` - A web server, connected to `port_2`
3. `database` - A database server, connected to `port_3`

All instances use the `c4-r8-d80` flavor and a specified image ID. You must replace the `image_id` with the ID of the image you want to use. The instances are also associated with the `default` security group and the custom security groups created in this setup.

## Ports

Three ports are created and connected to the private network:

1. `port_1` - Connected to the `jumpmachine`
2. `port_2` - Connected to the `webserver`
3. `port_3` - Connected to the `database`

## Floating IP

A floating IP is created from the "public" network pool (replace `pool` with the name of your "public" network) and is associated with the `jumpmachine` instance.