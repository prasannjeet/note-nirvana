#!/bin/bash

# Read the Terraform variables
USER_KEYPAIR="${TF_VAR_user_keyPair}"

# Generate ansible.cfg
cat << EOF > ansible.cfg
[defaults]
host_key_checking = False
private_key_file = ${USER_KEYPAIR}.pem

[ssh_connection]
ssh_args = -o ControlMaster=auto -o ControlPersist=60s -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no
EOF

# Read IPs from the text files
JUMPMACHINE_IP=$(grep jumpmachine local_ips.txt | awk '{print $2}')
WEBSERVER_IP=$(grep webserver local_ips.txt | awk '{print $2}')
DATABASE_IP=$(grep database local_ips.txt | awk '{print $2}')
PUBLIC_IP=$(cat floating_ip.txt)

# Generate inventory.ini
cat << EOF > inventory.ini
[jumpmachine_group]  # Renamed the group
jumpmachine ansible_host=${PUBLIC_IP} ansible_user=ubuntu ansible_ssh_private_key_file=${USER_KEYPAIR}.pem

[instances]
webserver ansible_host=${WEBSERVER_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/${USER_KEYPAIR}.pem
database ansible_host=${DATABASE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/${USER_KEYPAIR}.pem
jumpmachine-local ansible_host=${JUMPMACHINE_IP} ansible_user=ubuntu ansible_ssh_private_key_file=/home/ubuntu/.ssh/${USER_KEYPAIR}.pem

[all_instances:children]
instances
EOF
