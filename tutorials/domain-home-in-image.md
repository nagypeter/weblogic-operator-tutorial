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

- [Oracle Cloud Infrastructure](https://cloud.oracle.com/en_US/cloud-infrastructure) enabled account. The tutorial has been tested using [Trial account](https://myservices.us.oraclecloud.com/mycloud/signup) (as of January, 2019).
- Desktop with Oracle Cloud Infrastructure CLI, `kubectl`, `helm`. [Download](https://drive.google.com/open?id=11CvOZ-j50-2q9-rrQmxpEwmQZbPMkw2a) and import the preconfigured VirtualBox image (total required space > 12 GB)
  - [Download VirtualBox](https://www.virtualbox.org/wiki/Downloads) if necessary.
- [Docker](https://hub.docker.com/) account.
- [Github ](sign.up.github.md) account.
- [Oracle Container Pipeline](sign.up.wercker.md)

#### Before you start update HOL desktop environment (VirtualBox image) ####

Depending on your network connection make sure you switched ON or OFF the proxy configuration by clicking the corresponding shortcut on the desktop.

After the proxy configuration double click the **Update** icon and wait until the update process complete. Hit enter when you see the *Press [Enter] to close the window* message to close the update terminal.

![](images/update.HOL.png)

### The topics to be covered in this hands-on session are: ###

0. [Setup Oracle Kubernetes Engine instance on Oracle Cloud Infrastructure.](setup.oke.md)
1. [Create Oracle Container Pipelines Application to Build Custom WebLogic Domain Image](build.weblogic.image.pipeline.md)
2. [Install WebLogic Operator](install.operator.md)
3. [Install Traefik Software Loadbalancer](install.traefik.md)
4. [Deploy WebLogic Domain](deploy.weblogic.md)
5. [Scaling WebLogic Cluster](scale.weblogic.md)
6. [Override JDBC Datasource parameters](override.jdbc.md)
7. [Update Web Application](update.application.md)
8. [Assigning WebLogic Pods to Nodes](node.selector.md)
