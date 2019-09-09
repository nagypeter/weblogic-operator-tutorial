# Oracle Open World 2019 - HOL 5312 #

### Install and configure Operator  ###

An operator is an application-specific controller that extends Kubernetes to create, configure, and manage instances of complex applications. The Oracle WebLogic Server Kubernetes Operator (the "operator") simplifies the management and operation of WebLogic domains and deployments.

Every participant will create own kubernetes namespace and will install operator into the own namespace.

#### Install the Operator operator with a Helm chart ####

Kubernetes distinguishes between the concept of a user account and a service account for a number of reasons. The main reason is that user accounts are for humans while service accounts are for processes, which run in pods. WebLogic Operator also requires service accounts.  If service account not specified, it defaults to default (for example, the namespace's default service account). If you want to use a different service account, then you must create the operator's namespace and the service account before installing the operator Helm chart.

Thus create operator's namespace in advance (don't forget to replace proper USER ID with the ID given you by Instructor:

    kubectl create namespace sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID>

Create the service account:

    kubectl create serviceaccount -n sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID> sample-weblogic-operator-sa

Make sure before execute operator `helm` install you are in the WebLogic Operator's local Git repository folder (inside VM).

    cd /u01/content/weblogic-kubernetes-operator/

Use the `helm install` command to install the operator Helm chart. As part of this, you must specify a "release" name for their operator.

You can override default configuration values in the operator Helm chart by doing one of the following:

- Creating a [custom YAML](https://github.com/oracle/weblogic-kubernetes-operator/blob/2.0/kubernetes/charts/weblogic-operator/values.yaml) file containing the values to be overridden, and specifying the `--value` option on the Helm command line.
- Overriding individual values directly on the Helm command line, using the `--set` option.

Using the last option simply define overriding values using the `--set` option.

Note the values:

- **name**: name of the resource
- **namespace**: where the operator deployed
- **image**: the prebuilt WebLogic Operator 2.0 image. Available on public Docker hub.
- **serviceAccount**: service account required to run operator
- **domainNamespaces**: namespaces where WebLogic domains will be deployed in order to control. We will create that namespace later during HOL

Execute the following `helm install`:
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

Check the operator pod:
```
$ kubectl get po -n sample-weblogic-operator-ns-<PLEASE REPLACE THIS PART WITH YOUR USER ID>
NAME                                READY     STATUS    RESTARTS   AGE
weblogic-operator-f669874df-sl9cn   1/1       Running   0          1m
```
Check the operator helm chart:
```
$ helm list sample-weblogic-operator
NAME                    	REVISION	UPDATED                 	STATUS  	CHART              	NAMESPACE                  
sample-weblogic-operator	1       	Mon Feb  4 19:10:56 2019	DEPLOYED	weblogic-operator-2	sample-weblogic-operator-ns
```

The WebLogic Operator has been installed. You can continue with next tutorial module - [Deploy WebLogic Domain](deploy.weblogic_oow.md).
