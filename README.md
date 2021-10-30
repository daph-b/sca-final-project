# Deploy An Application TO GKE With A Cloud SQL Database Using Terraform
contains submodules for provisioning  a private cloud SQL instance, a GKE cluster and kubernetes resources/objects. 


## Usage
Each submodule should be treated as a different apply operation. 
The cluster and the SQL instance must be provisioned before creating the kubernetes objects as it depends on both.<br /> 
Each submodule contains a README.md file that gives module specific information.


## Remote Backend
Each submodule stores its statefiles, variables and environment variables in a terraform cloud workspace. 
to store the statefile locally, delete the terraform backend block and run terraform init

the service account key to authenticate terraform to the google provider is stored as the environment variable GOOGLE_CREDENTIALS in each workspace.



click on the link to visit the fully deployed application
https://finance.revevellidan.com
