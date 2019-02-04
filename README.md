# Welcome to Oracle WebLogic Operator Tutorial #

### About this hands-on tutorial ###

This tutorial demonstrates how to deploy and run WebLogic Domain on Kubernetes Cluster using [Oracle WebLogic Server Kubernetes Operator](https://github.com/oracle/weblogic-kubernetes-operator).

This lab is designed for people with no prior experience with OCI, Kubernetes, WebLogic, Container Registry, Docker and want to learn the core concepts and basics of how to run WebLogic JEE application on Kubernetes environment.

Oracle services being used during the hands-on are the following:

+ **Oracle Cloud Infrastructure (OCI)** which combines the elasticity and utility of public cloud with the granular control, security, and predictability of on-premises infrastructure to deliver high-performance, high availability and cost-effective infrastructure services.
+ **Oracle Container Pipelines (OCP - former Wercker)** is a Docker-Native CI/CD  Automation platform for Kubernetes & Microservice Deployments. OCP is integrated with Docker containers, which package up application code and can be easily moved from server to server. Each build artifact can be a Docker container. The user can take the container from the Docker Hub or his private registry and build the code before shipping it. Its SaaS platform enables developers to test and deploy code often. They can push software updates incrementally as they are ready, rather than in bundled dumps. It makes it easier for coders to practice continuous integration, a software engineering practice in which each change a developer makes to the codebase is constantly tested in the process so that software doesn’t break when it goes live.
+ **Oracle Cloud Infrastructure Registry (OCIR)** is a v2 container registry hosted on OCI to store and retrieve containers.
+ **Oracle Container Engine for Kubernetes (OKE)** is an Oracle managed Kubernetes Cluster enviroment to deploy and run container packaged applications.
+ **Oracle Weblogic Kubernetes Operator** open source component to run WebLogic on Kubernetes.

### The topics to be covered in this tutorial: ###

1. [Build and deploy WebLogic domain on Kubernetes using Docker image with the WebLogic domain inside the image deployment](tutorials/domain-home-in-image.md)
(a.k.a. *Domain-home-in-image* version using WebLogic Operator 2.0)
  - Create custom WebLogic domain image using Oracle Pipelines
  - Install software Loadbalancer
  - Install WebLogic Operator
  - Deploy WebLogic domain on Kubernetes
  - Scale WebLogic Cluster
  - Override domain configuration
  - Update demo application
2. [Deploy WebLogic domain on Kubernetes using Persistence Volumes](https://github.com/nagypeter/weblogic-on-oke-workshop/blob/master/tutorials/setup.weblogic.kubernetes.dk.md) (using WebLogic Operator 1.1)
  - Setup NFS share on Kubernetes Cluster worker nodes
  - Install software Loadbalancer and WebLogic Operator
  - Deploy WebLogic domain using official WebLogic image from Docker Store
  - [Deploy demo application using Oracle Pipelines](https://github.com/nagypeter/weblogic-on-oke-workshop/blob/master/tutorials/sample.app.pipeline.md)

### License ###
Copyright (c) 2019 Oracle and/or its affiliates
The Universal Permissive License (UPL), Version 1.0
