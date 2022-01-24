# Setup script for Grafana with AWS Timestream
With this script a Grafana instance can be easily set up on the Raspberry Pi. In addition the AWS Timestream data source can be added directly by providing the Access and Secret Key of your AWS account. Before running the script please make sure to install the required python modules. To do this, you need to navigate to the directory where you cloned the repository

```
pip3 install -r requirements.txt
```

After the install set the permissions of the `setup.sh` script to:

```
chmod 755 setup.sh
```

Within the repositories directory run `./setup.sh`