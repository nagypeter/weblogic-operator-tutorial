# Oracle WebLogic Operator Tutorial #

### Deploy Oracle WebLogic Domain (*Domain-home-in-image*) on Kubernetes using Oracle WebLogic Operator  ###

This lab demonstrates how to deploy and run Weblogic Domain container packaged Web Application on Kubernetes Cluster using [Oracle WebLogic Server Kubernetes Operator 2.0](https://github.com/oracle/weblogic-kubernetes-operator).

The demo Web Application is a simple JSP page which shows WebLogic Domain's MBean attributes to demonstrate WebLogic Operator features.

**Architecture**

WebLogic domain can be located either in a persistent volume (PV) or in a Docker image. [There are advantages to both approaches, and there are sometimes technical limitations](https://github.com/oracle/weblogic-kubernetes-operator/blob/2.0/site/domains.md#create-and-manage-weblogic-domains) of various cloud providers that may make one approach better suited to your needs.

This tutorial implements the Docker image with the WebLogic domain inside the image deployment. This means all the artefacts, domain related files are stored within the image. There is no central, shared domain folder from the pods. This is similar to the standard installation topology where you distribute your domain to different host to scale out Managed servers. The main difference is that using container packaged WebLogic Domain you don't need to use pack/unpack mechanism to distribute domain binaries and configuration files between multiple host.

![](images/wlsonk8s.domain-home-in-image.png)

In Kubernetes environment WebLogic Operator ensures that only one Admin and multiple Managed servers will run in the domain. An operator is an application-specific controller that extends Kubernetes to create, configure, and manage instances of complex applications. The Oracle WebLogic Server Kubernetes Operator (the "operator") simplifies the management and operation of WebLogic domains and deployments.

Helm is a framework that helps you manage Kubernetes applications, and helm charts help you define and install Helm applications into a Kubernetes cluster. Helm has two parts: a client (Helm) and a server (Tiller). Tiller runs inside of your Kubernetes cluster, and manages releases (installations) of your charts.

This tutorial has been tested on Oracle Cloud Infrastructure Container Engine for Kubernetes (OKE).

### Prerequisites ###

We recommend to run the client software (kubectl, git, helm) in of two environments: either inside Virtual Box on local machine or in the OCI Compute VM in the Oracle Cloud. 

#### Option 1: Running client in Virtual Box ####

- [Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure) enabled account. The tutorial has been tested using [Trial account](https://myservices.us.oraclecloud.com/mycloud/signup) (as of January, 2019).
- Desktop with Oracle Cloud Infrastructure CLI, `kubectl`, `helm`. [Download](https://drive.google.com/file/d/140JW-H5zzh0P709W-hdUPcbw_HZy2XcX), import VirtualBox image (total required space: OVA + imported image < 7 GB) and run configuration script to get tested environment for this workshop.
  - If necessary first [download VirtualBox](https://www.virtualbox.org/wiki/Downloads) desktop software.
- Inside Virtual Box open a terminal window and execute the following configuration script to prepare your desktop environment (VirtualBox image).
```bash
bash <(curl -s https://raw.githubusercontent.com/nagypeter/vmcontrol/master/setup-operator-workshop.sh)
```
- Close the terminal when the script has finished.

#### Option 2: Running client in OCI Compute VM ####

To setup the client VM in Oracle Cloud please  then follow this [tutorial](setup.dev.compute.instance.md). You later connect to that VM   through `ssh`.
However in that case have in mind that the operator sources were cloned to the `/home/opc/` folder and the folder `/u01/content` doesn't exist in the VM. So whenever the tutorial asks you to change the current folder to `/u01/content/...` you should really move to `/home/opc/...`



### The topics to be covered in this hands-on session are: ###

1. [Setup Oracle Kubernetes Engine instance on Oracle Cloud Infrastructure.](setup.oke.md)
2. [Install WebLogic Operator](install.operator.md)
3. [Install Traefik Software Loadbalancer](install.traefik.md)
4. [Deploy WebLogic Domain](deploy.weblogic_short.md)
5. [Scaling WebLogic Cluster](scale.weblogic.md)
6. [Override JDBC Datasource parameters](override.jdbc.md)
7. [Updating deployed application by rolling restart to the new image](update.application_short.md)
7. [Assigning WebLogic Pods to Nodes (scenario simulating cluster spanning 2 data center)](node.selector.md)
8. [Assigning WebLogic Pods to Nodes (scenario simulating licensing only the subset of the cluster)](node.selector.license.md)
