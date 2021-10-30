# Provisioning A Private Cloud SQL Instance Using Terraform.
This module provisions a cloud sql instance, creates a private connection between the default network and cloud sql using VPC-peering,<br />
so that any compute engine instances on the default network can connect privately to the instance. 


## Required Variables
* project_id: the google cloud project in which to provision the instance.
* region : the region in which to provision the instance
* db_user : the user to create for the instance
* db_pass : the password for the db_user
* database_name : the name of the databse to create in the instance.


## Other Variables
These variables can be overwritten but if not provided uses the default values
* database_version : type of instance to be created.defaults to POSTGRES_13.valid values include SQLSERVER_2017_WEB, POSTGRES_9_6, MYSQL_8_0, etc
* availability : availability type for the instance. could be "REGIONAL" or "ZONAL". defaults to "ZONAL"
* prefix_length: netmask for the reserved peering range. defaults to 16


