# Deploy An Application TO GKE With A Cloud SQL Database Using Terraform
This project pulls an application image from google’s artifact registry and deploys the application to google kubernetes <br />
engine with a cloud sql instance database. This whole process is automated using terraform.

The repository is divided into submodules that provision the sql instance, the cluster and finally the kubernetes. <br />
These submodules represent different apply operations as some features of kubernetes don't work when the cluster and <br />
the kubernetes are provisioned in the same apply operation. 

Each submodule is created in a modular fashion and thus can be reused. <br />
They each contain a README.md file that  gives further insight on the variables required to create each.

Relevant Data about the cluster and the database needed by the kubernetes are exported to a cloud storage <br />
bucket and accessed by the kubernetes submodule using data blocks.


## Usage
Each submodule should be treated as a different apply operation. 
The cluster and the SQL instance must be provisioned before creating the kubernetes objects as it depends on both.<br /> 
Each submodule contains a README.md file that gives module specific information.


## Remote Backend
Each submodule stores its statefiles, variables and environment variables in a terraform cloud workspace. <br />
To store the statefile locally, delete the terraform backend block and run terraform init

The service account key to authenticate terraform to the google provider is stored as the environment <br />
variable GOOGLE_CREDENTIALS in each workspace.


click on the link to visit the fully deployed application
https://finance.revevellidan.com
