# Oracle Open World 2019 - HOL 5312 #

### Install and configure Operator  ###

An operator is an application-specific controller that extends Kubernetes to create, configure, and manage instances of complex applications. The Oracle WebLogic Server Kubernetes Operator (the "operator") simplifies the management and operation of WebLogic domains and deployments.

Every participant will create own kubernetes namespace and will install operator into the own namespace.

#### Install the Operator operator with a Helm chart ####

Kubernetes distinguishes between the concept of a user account and a service account for a number of reasons. The main reason is that user accounts are for humans while service accounts are for processes, which run in pods. WebLogic Operator also requires service accounts.  If service account not specified, it defaults to default (for example, the namespace's default service account). If you want to use a different service account, then you must create the operator's namespace and the service account before installing the operator Helm chart.

Thus create operator's namespace in advance (don't forget to replace proper USER ID with the ID given you by Instructor):

    kubectl create namespace sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID>

Create the service account:

    kubectl create serviceaccount \
     -n sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID> \
     sample-weblogic-operator-sa

Make sure before execute operator `helm` install you are in the WebLogic Operator's local Git repository folder (inside VM).

    cd /u01/content/weblogic-kubernetes-operator/

It is good practice to upgrade tiller service on server side before you start using helm. So please execute the following command

    helm init --upgrade

Use the `helm install` command to install the operator Helm chart. As part of this, you must specify a "release" name for their operator. In this HOL you will share Kubernetes cluster with other participants. This is why your Operator release name must be unique and we add there your USER ID. The configuration for the Helm chart was downloaded from github repository when we cloned in advance the repository with WebLogic Operator.

Note the syntax of the helm install command requires the following parameters:

- **name**: name of the release - in our case unique name of the operator that you try to deploy to kubernetes cluster
- **namespace**: namespace in the kubernetes cluster where the operator will be deployed to (the one that you just created)
- **image**: the prebuilt WebLogic Operator 2.0 image. Available on public Docker hub.
- **serviceAccount**: service account required to run operator (the one that you just created)
- **domainNamespaces**: namespaces that operator will monitor for Custom Resource object. Operator will create all pods with WebLogic domains inside these namespaces. We will create that namespace later during HOL

So at the begining you need to execute the following `helm install`:
```
helm install kubernetes/charts/weblogic-operator \
  --name sample-weblogic-operator-<PLEASE REPLACE THIS PART WITH YOUR USER ID> \
  --namespace sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID> \
  --set image=oracle/weblogic-kubernetes-operator:2.0 \
  --set serviceAccount=sample-weblogic-operator-sa \
  --set "domainNamespaces={}"
```
The result has to be similar:
```
NAME:   sample-weblogic-operator
LAST DEPLOYED: Mon Feb  4 13:10:56 2019
NAMESPACE: sample-weblogic-operator-ns-XXX
STATUS: DEPLOYED

RESOURCES:
==> v1beta1/Deployment
NAME               DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
weblogic-operator  1        1        1           1          14s

==> v1/Secret
NAME                       TYPE    DATA  AGE
weblogic-operator-secrets  Opaque  0     15s

==> v1/ClusterRole
NAME                                                                      AGE
sample-weblogic-operator-ns-weblogic-operator-clusterrole-domain-admin    15s
sample-weblogic-operator-ns-weblogic-operator-clusterrole-general         14s
sample-weblogic-operator-ns-weblogic-operator-clusterrole-namespace       14s
sample-weblogic-operator-ns-weblogic-operator-clusterrole-nonresource     14s
sample-weblogic-operator-ns-weblogic-operator-clusterrole-operator-admin  14s

==> v1/Role
weblogic-operator-role  14s

==> v1/Service
NAME                            TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)   AGE
internal-weblogic-operator-svc  ClusterIP  10.96.237.168  <none>       8082/TCP  14s

==> v1/ConfigMap
NAME                  DATA  AGE
weblogic-operator-cm  2     15s

==> v1/ClusterRoleBinding
NAME                                                                             AGE
sample-weblogic-operator-ns-weblogic-operator-clusterrolebinding-nonresource     14s
sample-weblogic-operator-ns-weblogic-operator-clusterrolebinding-auth-delegator  14s
sample-weblogic-operator-ns-weblogic-operator-clusterrolebinding-discovery       14s
sample-weblogic-operator-ns-weblogic-operator-clusterrolebinding-general         14s

==> v1/RoleBinding
NAME                                     AGE
weblogic-operator-rolebinding-namespace  14s
weblogic-operator-rolebinding            14s

==> v1/Pod(related)
NAME                               READY  STATUS   RESTARTS  AGE
weblogic-operator-f669874df-sl9cn  1/1    Running  0         14s
```

To verify that the operator is ready to control the lifecycle of WebLogic domains please verify the status of the operator pod:
```
$ kubectl get po -n sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID>
NAME                                READY     STATUS    RESTARTS   AGE
weblogic-operator-f669874df-sl9cn   1/1       Running   0          1m
```


The WebLogic Operator has been installed. You can continue with next tutorial module - [Deploy WebLogic Domain](deploy.weblogic_oow.md).
