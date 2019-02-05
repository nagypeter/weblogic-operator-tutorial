# Oracle WebLogic Operator Tutorial #

### Deploy WebLogic domain  ###

#### Preparing the Kubernetes cluster to run WebLogic domains ####

Create the domain namespace:
```
kubectl create namespace sample-domain1-ns
```
Create a Kubernetes secret containing the Administration Server boot credentials:
```
kubectl -n sample-domain1-ns create secret generic sample-domain1-weblogic-credentials \
  --from-literal=username=weblogic \
  --from-literal=password=welcome1
```
Label the secret with domainUID:
```
kubectl label secret sample-domain1-weblogic-credentials \
  -n sample-domain1-ns \
  weblogic.domainUID=sample-domain1 \
  weblogic.domainName=sample-domain1
```
Create OCI image Registry secret to allow Kubernetes to pull you custome WebLogic image. Replace the registry server region code, username and auth token respectively.
```
kubectl create secret docker-registry ocirsecret \
  -n sample-domain1-ns \
  --docker-server=YOUR_HOME_REGION_CODE.ocir.io \
  --docker-username='YOUR_TANACY_NAME/YOUR_OCIR_USERNAME' \
  --docker-password='YOUR_OCIR_AUTH_TOKEN' \
  --docker-email='YOUR_EMAIL'
```
For example:
```
$ kubectl create secret docker-registry ocirsecret \
  -n sample-domain1-ns \
  --docker-server=fra.ocir.io \
  --docker-username='johnpsmith/oracleidentitycloudservice/john.p.smith@example.com' \
  --docker-password='mypassword' \
  --docker-email=john.p.smith@example.com
  secret "ocirsecret" created
```

#### Update Traefik loadbalancer and WebLogic Operator configuration ####

Once you have your domain namespace (WebLogic domain not yet deployed) you have to update loadbalancer's and operator's configuration about where the domain will be deployed.

Make sure before execute domain `helm` install you are in the WebLogic Operator's local Git repository folder.
```
cd /u01/content/weblogic-kubernetes-operator/
```
To update operator execute the following `helm upgrade` command:
```
helm upgrade \
  --reuse-values \
  --set "domainNamespaces={sample-domain1-ns}" \
  --wait \
  sample-weblogic-operator \
  kubernetes/charts/weblogic-operator
```

To update Traefik execute the following `helm upgrade` command:
```
helm upgrade \
  --reuse-values \
  --set "kubernetes.namespaces={traefik,sample-domain1-ns}" \
  --wait \
  traefik-operator \
  stable/traefik
```
Please note the only updated parameter in both cases is the domain namespace.

#### Deploy WebLogic domain on Kubernetes ####

To deploy WebLogic domain you need to create a domain resource definition which contains the necessary parameters for the operator to start the WebLogic domain properly.

You can modify the provided sample in the local repository or better if you make a copy first.
```
cp /u01/content/weblogic-kubernetes-operator/kubernetes/samples/scripts/create-weblogic-domain/manually-create-domain/domain.yaml \
/u01/domain.yaml
```
Use your favourite text editor to modify domain resource definition values. If necessary remove comment leading character (#) of the parameter to activate. Always enter space before the value, after the colon.

Set the following values:

| Key | Value | Example |
|-|-|-|
|name:|sample-domain1||
|namespace:|sample-domain1-ns||
|weblogic.domainUID:|sample-domain1||
|domainHome:|/u01/oracle/user_projects/domains/sample-domain1||
|image:|YOUR_OCI_REGION_CODE.ocir.io/YOUR_TENANCY_NAME/weblogic-operator-tutorial:latest|"fra.ocir.io/johnpsmith/weblogic-operator-tutorial:latest"|
|imagePullPolicy:|"Always"||
|imagePullSecrets: <br>- name:|imagePullSecrets: <br>- name: ocirsecret||
|webLogicCredentialsSecret: <br>- name:|webLogicCredentialsSecret: <br>- name: sample-domain1-weblogic-credentials||

Save the changes and create domain resource using the apply command:
```
kubectl apply -f /u01/domain.yaml
```
Check the introspector job which needs to be run first:
```
$ kubectl get pod -n sample-domain1-ns
NAME                                         READY     STATUS              RESTARTS   AGE
sample-domain1-introspect-domain-job-kcn4n   0/1       ContainerCreating   0          7s
```
Check periodically the pods in the domain namespace and soon you will see the servers are starting:
```
$ kubectl get po -n sample-domain1-ns -o wide
NAME                             READY     STATUS    RESTARTS   AGE       IP            NODE            NOMINATED NODE
sample-domain1-admin-server      1/1       Running   0          2m        10.244.2.10   130.61.84.41    <none>
sample-domain1-managed-server1   1/1       Running   0          1m        10.244.2.11   130.61.84.41    <none>
sample-domain1-managed-server2   0/1       Running   0          1m        10.244.1.4    130.61.52.240   <none>
```
You have to see three running pods similar to the result above. If you don't see all the running pods please wait and check periodically. The whole domain deployment may take up to 2-3 minutes depending on the compute shapes.

The WebLogic Administration server console is exposed to the external world using NodePort. Which means you can use any of the node's public IP address as host name. The NodePort definition can be found in the domain resource defintion (*domain.yaml*) which default is 30701 if you haven't modified.

Construct the Administration Console's url and open in a browser:

`http://ANY_NODE_PUBLIC_IP_ADDRESS:30701/console`

Enter admin user credentials (weblogic/welcome1) and click **Login**

![](images/deploy.domain/weblogic.console.login.png)

!Please note in this use case the use of Administration Console is just for demo/test purposes because domain configuration persisted in pod which means after the restart the original values (baked into the image) will be used again. To override certain configuration parameters - to ensure image portability - follow the override part of this tutorial.

#### Test the demo Web Application ####

In order to access any application deployed on WebLogic you have to configure Traefik ingress.

As a simple solution the best is to configure path routing which will route the traffic external traffic through Traefik to domain cluster address.

Execute the following ingress resource definition:
```
cat << EOF | kubectl apply -f -
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: traefik-pathrouting-1
  namespace: sample-domain1-ns
  annotations:
    kubernetes.io/ingress.class: traefik
spec:
  rules:
  - host:
    http:
      paths:
      - path: /
        backend:
          serviceName: sample-domain1-cluster-cluster-1
          servicePort: 8001
EOF          
```

Please note the namespace, serviceName and servicePort definition. These are the properties of the domain resource deployed on Kubernetes.

Once the Ingress has been created construct the URL of the application based on the following pattern:

`http://ANY_NODE_PUBLIC_IP_ADDRESS:30305/opdemo/?dsname=testDatasource`

![](images/deploy.domain/webapp.png)

Refresh the page and notice the hostname changes. It reflects the managed server's name which responds to the request. You should see the loadbalancing between the two managed server.
