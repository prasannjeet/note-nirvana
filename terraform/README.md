# Infrastructure Monitoring with Grafana, Prometheus, and Exporters in Terraform

## Introduction

Here, we will comprehensively describe how we set up a monitoring stack for our OpenStack instances using Grafana, Prometheus, Node Exporter, and MySQLd Exporter within the Terraform framework. For those unfamiliar with these technologies:

-   **Grafana**: An open-source platform for monitoring and observability, providing you with the ability to visualize, explore, and alert on metrics from different data sources.
    
-   **Prometheus**: A leading open-source monitoring solution that records real-time metrics in a time-series database.
    
-   **Node Exporter**: A Prometheus exporter for hardware and OS metrics with pluggable metric collectors, allowing you to measure various machine resources such as memory, disk I/O, CPU, network, etc.
    
-   **MySQLd Exporter**: A Prometheus exporter for MySQL server metrics. It provides insight into the performance characteristics of MySQL databases.
    

## Setting up the Monitoring Stack

In this project, we use Terraform to orchestrate our infrastructure setup, and we focus on visualizing our OpenStack instances' statistics.

1.  **Deploying Grafana, Prometheus, and Node Exporter**: We install these components on our jump machine using Docker, effectively isolating their environment and ensuring consistent operation regardless of the host system.
    
    In this setup, we move the Docker Compose files to the jump machine and initiate the Docker containers. This procedure gets us up and running with Grafana, Prometheus, and Node Exporter on the jump machine.
    
    We have meticulously configured our Docker Compose file to include all necessary data sources for Grafana, as well as all the details required to create Grafana dashboards. This configuration includes a `dashboard.json` file for the dashboard settings and a `datasources.yml` file for data source settings. With these configurations, our Grafana instance is equipped to automatically create a dashboard that can visualize the jump machine's statistics.
    
2.  **Extending Monitoring to Other Instances**: Using Ansible, we install Prometheus and Node Exporter on our other instances, i.e., the database and web server instances. Once deployed, Grafana on the jump machine can fetch metrics from these instances and present them in the same dashboard. As a result, we achieve a unified monitoring dashboard visualizing all three instances.
    

## Monitoring MySQL Database Statistics

We go a step further to set up a specialized Grafana dashboard for visualizing statistics of our MySQL database deployed on the database instance.

-   **Prometheus and MySQLd Exporter Setup**: We create a new Prometheus server on the database instance, run inside Docker. This new Prometheus server is integrated with the MySQLd Exporter, a custom exporter designed to fetch and expose MySQL statistics.
    
-   **Extending Grafana to Connect to New Prometheus**: We configure our original Grafana instance on the jump machine to accept connections from the new Prometheus on the database instance. This setup allows us to visualize the MySQL database details fetched by the new Prometheus server in a separate Grafana dashboard.
    


## Conclusion

Our Terraform setup thus achieves comprehensive monitoring of our OpenStack instances. We have two dashboards within Grafana:

1.  **General Dashboard**: This dashboard provides an overview of all three instances, offering complete statistics fetched using the Node Exporters deployed on each instance.
    
2.  **Database Dashboard**: This separate dashboard specifically visualizes statistics for the MySQL database, fetched from the new Prometheus server integrated with MySQLd Exporter.
    

This setup gives us the power of a holistic and specific analysis, with one dashboard responsible for monitoring and displaying statistics for all three instances, and another focusing on the MySQL database specifically. With this robust setup, we ensure maximum visibility and awareness about the performance and health of our infrastructure, enabling us to take swift action in response to any issues and maintain high levels of performance and reliability.

By leveraging the capabilities of Grafana, Prometheus, and exporters, we are better equipped to handle the complexities of our OpenStack instances, delivering on the promise of modern infrastructure management.

# Deploy the terraform stack
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
	Just run the following commands in your terminal.

	```
	export TF_VAR_user_name="<username>"
	export TF_VAR_tenant_name="<tenant-name>"
	export TF_VAR_tenant_id="<tenant-id>"
	export TF_VAR_user_domain_name="Default"
	export TF_VAR_password="<pssword>"
	export TF_VAR_auth_url="https://cscloud.lnu.se:5000/v3"
	export TF_VAR_region="RegionOne"
	export TF_VAR_user_keyPair="<key-pair-name for all instances in cscloud>"
	export TF_VAR_default_sg_id="<id of default security group in cscloud>"
	export TF_VAR_public_network_id="<id of public network in cscloud>"
	```

4. Ensure that `rsync` in installed in your computer. If not, run `brew install rsync` to install (for mac). We use rsync to copy files to jumpmachine based on the `.gitignore` file.
5. **Important:** _Rename Your Key File:_ Ensure that your key file (.pem file) is located in the terraform folder. Please note that the file name of the key file must be the same as the environment variable `TF_VAR_user_keyPair`.
   For example, if my kye-pair name (in cscloud) is `ps222vt_Keypair`, then:
   1. I rename my pem file to `ps222vt_Keypair.pem`
   2. I add the env variable `export TF_VAR_user_keyPair="ps222vt_Keypair"`
   3. I move the pem file to terraform folder.
   4. Ensure that pem file has 600 permissions: `chmod 600 ps222vt_Keypair.pem`.
6. Ensure that the executable file `generate_ansible_files.sh` and `add-keycloak-cors.sh` has been given `+x` permission. `sudo chmod +x ./generate_ansible_files.sh` and `sudo chmod +x ./add-keycloak-cors.sh`.
7. Ensure that the id of your default security group is added in the env variable `TF_VAR_default_sg_id`. 
   Furthermore, make sure that the following ports are not already open in your `default` security group rules, because we will create those rules via terraform. If these ports already exist, it may lead to error:
   1. Port `22`
   2. Port `3000`
   3. Port `8080`
   4. Port `9100`
   5. Port `9090`
   6. Port `3457`
8. Ensure that the id of your public network in cscloud is added to the env variable `TF_VAR_public_network_id`. You can find the id in your cscloud account.

## Deploy the Infrastructure

1.  Verify the Terraform plan:
    
```
terraform plan -out="my_plan.tfplan"
```
    
2.  Apply the Terraform configuration:
    
```
terraform apply "my_plan.tfplan"
```
    
3. After everythign is provisioned, It will create "endpoints.txt" file with url's to visit the app's frontend as well as backend.

## Infrastructure Overview

-   **Servers:**
    
    -   Jump Server: A jump server with SSH, HTTP, HTTPS, and TCP access
    -   Web Server: A web server with SSH, HTTP, HTTPS, and TCP access
    -   Database Server: A database server with SSH, HTTP, HTTPS, and TCP access

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
- `default_sg_id`
- `public_network_id`

## Security Groups

There are four security groups created in this setup:

1. `ssh` - Allows SSH access (port 22) from any IP address
address
2. `3000` - Port 3000 for frontend application
3. `8080` - Port 8080 for backend application
4. `9100` - Port 9100 for node exporter
5. `9090` - Port 9090 for prometheus
6. `3457` - Port 3457 for grafana

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