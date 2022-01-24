#!/bin/bash

# Author: Tim Schmid
# Projekt: EC2 - ECE19

HLINE='---------------------------------------------------------------'
GRAFANA_INSTALL_STATE="$(apt list --installed 2> /dev/null | grep grafana)"
# scripts path in local repo
SCRIPT_PATH=$(dirname `which $0`)
REPO_DATASOURCE_DIR="$SCRIPT_PATH/provisioning/datasources/sources.yaml"

# Secrets script
SECRETS_SCRIPT="$SCRIPT_PATH/secrets.py"

# path to datasource config on the pi
DATASOURCE_DIR="/etc/grafana/provisioning/datasources"
DATASOURCE_FILE="$DATASOURCE_DIR/sources.yaml"

function install_grafana {
      echo -e "\n$HLINE"
      wget -q -O - https://packages.grafana.com/gpg.key | sudo apt-key add -
      echo "deb https://packages.grafana.com/oss/deb stable main" | sudo tee -a /etc/apt/sources.list.d/grafana.list
      sudo apt-get update
      sudo apt-get install -y grafana
      echo "Grafana successfully installed"
      echo -e "$HLINE\n"
}

function add_datasource {
    echo -e "\n$HLINE"
    echo -e "Please add your AWS access and secret key: "
    echo -e "$HLINE"
    python3 $SECRETS_SCRIPT
    echo -e "\n$HLINE"
    echo -e "Copy all essential files \n"

    if [ ! -f $DATASOURCE_FILE ]; then 
      touch $DATASOURCE_FILE
    fi

    echo -e "from $REPO_DATASOURCE_DIR \n"
    echo -e "to $DATASOURCE_FILE"
    sudo cp $REPO_DATASOURCE_DIR $DATASOURCE_FILE
    echo -e "$HLINE\n"
}

function add_service {
    echo -e "\n$HLINE"
    echo -e "Regsiter the grafana-server service \n"
    sudo /bin/systemctl enable grafana-server 
    sudo /bin/systemctl start grafana-server  
    echo -r "Successfully added"
    echo -e "$HLINE\n"

    IP="$(hostname -I)"
    IP_STRING="${IP::-1}"
    echo "Your grafana instance is at: ${IP_STRING}:3000"
}

echo -e "\n$HLINE"
echo "Install script for a local grafana client"
echo -e "$HLINE\n"

read -p "Do you wish to install grafana? [y/n] " RESP
if [ "$RESP" = "y" ] || [ "$RESP" = "Y" ]; then
  install_grafana
fi

read -p "Do you wish to add the AWS Timestream Datasource? [y/n] " RESP
if [ "$RESP" = "y" ] || [ "$RESP" = "Y" ]; then
  add_datasource
fi

read -p "WARNING! READ CAREFULLY - Do you wish to register a sysctl service? [y/n] " RESP
if [ "$RESP" = "y" ] || [ "$RESP" = "Y" ]; then
  add_service
fi