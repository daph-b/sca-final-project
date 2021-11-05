# Deploy an application to an already existing cluster in gke using Terrform
This uses a multi container pod. with the application and cloud sql auth proxy as the side car container.<br />
Cloud sql auth proxy helps give the application secure access to a database on a cloud sql instance. <br />
This way, each pod lives and dies with its own access to the database.

The application image is pulled form a private artifact registry repository and the cloud sql image is pulled from a
 public container registry repository

Datablocks are used to get information about the cluster and the cloud SQL instance from a cloud storage bucket.

Custom resource definitions are used to  enable the addition of more features to the kubernetes setup.
The crds used in this module are:
 * the frontenconfig is applied on the ingress object to enable redirect of http traffic to https
 * the backendconfig is applied on the service to enable session affinity and custom health checks

container-native ingress is used to apply the health checks directly at the node. <br />
This is possible because we use a VPC-native cluster, and can route traffic directly to the pods.

kubernetes secrets are used to apply a user managed tls certificate to the ingress object.

## Required Variables
* project_id : the google project the resources should be provisioned in
* region: the region in which to provision the resources
* namespace: the kubernetes namespace inwhich to create the kubernetes objects.
* deployment_replica: the number of pods to deploy
* container_image: the application image



