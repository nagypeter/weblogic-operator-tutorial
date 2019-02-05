# Oracle WebLogic Operator Tutorial #

### Install and configure Traefik  ###

The Oracle WebLogic Server Kubernetes Operator supports three load balancers: Traefik, Voyager, and Apache. Samples are provided in the [documentation](https://github.com/oracle/weblogic-kubernetes-operator/blob/2.0/kubernetes/samples/charts/README.md).

This tutorial demonstrates how to install the [Traefik](https://traefik.io/) ingress controller to provide load balancing for WebLogic clusters.

#### Install the Traefik operator with a Helm chart ####

Note! If you don't use the prepared VirtualBox desktop environment first clone the WebLogic Operator git repository to your desktop.
```
git clone https://github.com/oracle/weblogic-kubernetes-operator.git  -b 2.0
```
Change to the WebLogic Operator local Git repository folder.

    cd /u01/content/weblogic-kubernetes-operator/

To install the Traefik operator in the traefik namespace with the provided sample values:

    helm install stable/traefik \
    --name traefik-operator \
    --namespace traefik \
    --values kubernetes/samples/charts/traefik/values.yaml  \
    --set "kubernetes.namespaces={traefik}" \
    --wait

The output should be similar:

     NAME:   traefik-operator
     LAST DEPLOYED: Mon Feb  4 10:58:41 2019
     NAMESPACE: traefik
     STATUS: DEPLOYED

     RESOURCES:
     ==> v1/ConfigMap
     NAME              DATA  AGE
     traefik-operator  1     24s

     ==> v1/ClusterRole
     NAME              AGE
     traefik-operator  23s

     ==> v1/Service
     NAME                        TYPE       CLUSTER-IP     EXTERNAL-IP  PORT(S)                     AGE
     traefik-operator-dashboard  ClusterIP  10.96.44.36    <none>       80/TCP                      23s
     traefik-operator            NodePort   10.96.133.236  <none>       80:30305/TCP,443:30443/TCP  23s

     ==> v1beta1/Ingress
     NAME                        HOSTS                ADDRESS  PORTS  AGE
     traefik-operator-dashboard  traefik.example.com  80       23s

     ==> v1/Pod(related)
     NAME                               READY  STATUS   RESTARTS  AGE
     traefik-operator-8486f75bbd-q6pz5  1/1    Running  0         23s

     ==> v1/Secret
     NAME                           TYPE    DATA  AGE
     traefik-operator-default-cert  Opaque  2     24s

     ==> v1/ServiceAccount
     NAME              SECRETS  AGE
     traefik-operator  1        23s

     ==> v1/ClusterRoleBinding
     NAME              AGE
     traefik-operator  23s

     ==> v1/Deployment
     NAME              DESIRED  CURRENT  UP-TO-DATE  AVAILABLE  AGE
     traefik-operator  1        1        1           1          23s


     NOTES:

     1. Traefik is listening on the following ports on the host machine:

          http - 30305
          https - 30443

     2. Configure DNS records corresponding to Kubernetes ingress resources to point to the NODE_IP/NODE_HOST

The Traefik installation is basically done. You can verify the Kubernetes resources:

    $ kubectl get po -n traefik -o wide
    NAME                                READY     STATUS    RESTARTS   AGE       IP           NODE           NOMINATED NODE
    traefik-operator-8486f75bbd-q6pz5   1/1       Running   0          20m       10.244.2.2   130.61.84.41   <none>

Also the `helm` charts:

    $ helm list
    NAME            	REVISION	UPDATED                 	STATUS  	CHART         	NAMESPACE
    traefik-operator	1       	Mon Feb  4 10:58:41 2019	DEPLOYED	traefik-1.59.2	traefik  

Or you can hit the Traefik's dashboard using `curl`. Use the node's IP address from the above result:

    curl -H 'host: traefik.example.com' http://NODE_IP_ADDRESS:30305/

For example:

    $ curl -H 'host: traefik.example.com' http://130.61.84.41:30305/
    <a href="/dashboard/">Found</a>.
