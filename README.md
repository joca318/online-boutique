<p align="center">
<img src="src/frontend/static/icons/Hipster_HeroLogoCyan.svg" width="300" alt="Online Boutique" />
</p>


![Continuous Integration](https://github.com/GoogleCloudPlatform/microservices-demo/workflows/Continuous%20Integration%20-%20Main/Release/badge.svg)

> **⚠ ATTENTION: Apache Log4j 2 advisory.**  
> Due to [vulnerabilities](https://cloud.google.com/log4j2-security-advisory) present in earlier versions
> of Log4j 2, we have taken down all affected container images. We highly recommend all demos and forks to now
> use images from releases [>= v0.3.4](https://github.com/GoogleCloudPlatform/microservices-demo/releases).

**Online Boutique** is a cloud-native microservices demo application.
Online Boutique consists of a 10-tier microservices application. The application is a
web-based e-commerce app where users can browse items,
add them to the cart, and purchase them.

**Google uses this application to demonstrate use of technologies like
Kubernetes/GKE, Istio, Stackdriver, gRPC and OpenCensus**. This application
works on any Kubernetes cluster, as well as Google
Kubernetes Engine. It’s **easy to deploy with little to no configuration**.

If you’re using this demo, please **★Star** this repository to show your interest!

> 👓**Note to Googlers:** Please fill out the form at
> [go/microservices-demo](http://go/microservices-demo) if you are using this
> application.

## Screenshots

| Home Page                                                                                                         | Checkout Screen                                                                                                    |
| ----------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| [![Screenshot of store homepage](./docs/img/online-boutique-frontend-1.png)](./docs/img/online-boutique-frontend-1.png) | [![Screenshot of checkout screen](./docs/img/online-boutique-frontend-2.png)](./docs/img/online-boutique-frontend-2.png) |

## Quickstart (GKE)

[![Open in Cloud Shell](https://gstatic.com/cloudssh/images/open-btn.svg)](https://ssh.cloud.google.com/cloudshell/editor?cloudshell_git_repo=https://github.com/GoogleCloudPlatform/microservices-demo&cloudshell_workspace=.&cloudshell_tutorial=docs/cloudshell-tutorial.md)

1. **[Create a Google Cloud Platform project](https://cloud.google.com/resource-manager/docs/creating-managing-projects#creating_a_project)** or use an existing project. Set the `PROJECT_ID` environment variable and ensure the Google Kubernetes Engine and Cloud Operations APIs are enabled.

```
the clusters are created already
```

2. **Clone this repository**

```
git clone https://github.com/joca318/online-boutique.git 
cd online-boutique
```

3. **Access GKE cluster ASM0[1-2]**

```
_ZONE_1=us-central1-c
_CLUSTER_1=asm01
_PROJECT_ID_1=service-project-256014
gcloud container clusters get-credentials --zone=$_ZONE_1 $_CLUSTER_1 --project $_PROJECT_ID_1
```

```
_ZONE_2=us-east1-c
_CLUSTER_2=asm02
_PROJECT_ID_2=d-iot-gpa01
ZONE=us-east1-c
gcloud container clusters get-credentials --zone=$_ZONE_2 $_CLUSTER_2 --project $_PROJECT_ID_2
```

4. **Deploy the sample app to the clusters [ASM0[1-2]**

```
gcloud builds submit --config=cloudbuild-kubectl-testbinauthz.yaml --substitutions=_ZONE_2=us-east1-c,_PROJECT_ID_2=d-iot-gpa01,_CLUSTER_2=asm02,_ZONE_1=us-central1-c,_PROJECT_ID_1=service-project-256014,_CLUSTER_1=asm01,_PROJECT_ID=service-project-256014,_SEVERITY=HIGH
```

**The binauthz uses the SEVERITY to Deploy the sample app to the clusters. [ASM0[1-2]. If the Severity is set to LOW, the binautz will block the deploy and show an error message:**
```
Starting Step #1 - "severity check"
Step #1 - "severity check": Already have image (with digest): gcr.io/google.com/cloudsdktool/cloud-sdk
Step #1 - "severity check": Failed vulnerability check
Finished Step #1 - "severity check"
ERROR
ERROR: build step 1 "gcr.io/google.com/cloudsdktool/cloud-sdk" failed: step exited with non-zero status: 1
```

```
gcloud builds submit --config=cloudbuild-kubectl-testbinauthz.yaml --substitutions=_ZONE_2=us-east1-c,_PROJECT_ID_2=d-iot-gpa01,_CLUSTER_2=asm02,_ZONE_1=us-central1-c,_PROJECT_ID_1=service-project-256014,_CLUSTER_1=asm01,_PROJECT_ID=service-project-256014,_SEVERITY=LOW
```
5. **Wait for the Pods to be ready.**

```
kubectl get pods
```

After a few minutes, you should see:

```
NAME                                     READY   STATUS    RESTARTS   AGE
adservice-76bdd69666-ckc5j               2/2     Running   0          2m58s
cartservice-66d497c6b7-dp5jr             2/2     Running   0          2m59s
checkoutservice-666c784bd6-4jd22         2/2     Running   0          3m1s
currencyservice-5d5d496984-4jmd7         2/2     Running   0          2m59s
emailservice-667457d9d6-75jcq            2/2     Running   0          3m2s
frontend-6b8d69b9fb-wjqdg                2/2     Running   0          3m1s
loadgenerator-665b5cd444-gwqdq           2/2     Running   0          3m
paymentservice-68596d6dd6-bf6bv          2/2     Running   0          3m
productcatalogservice-557d474574-888kr   2/2     Running   0          3m
recommendationservice-69c56b74d4-7z8r5   2/2     Running   0          3m1s
redis-cart-5f59546cdd-5jnqf              2/2     Running   0          2m58s
shippingservice-6ccc89f8fd-v686r         2/2     Running   0          2m58s
```

7. **Access the web frontend in a browser** using the frontend's `EXTERNAL_IP`.

```
kubectl get svc -n frontend -l istio=ingressgateway'
```

*Example output - do not copy*

```
EXTERNAL-IP
<your-ip>
```

**Note**- you may see `<pending>` while GCP provisions the load balancer. If this happens, wait a few minutes and re-run the command.

8. [Optional] **Clean up**:

```
skaffold delete -f skaffold-modules-deploy.yaml  --kube-context=asm01
skaffold delete -f skaffold-modules-deploy.yaml  --kube-context=asm02
```

## Other Deployment Options 
**to deploy using Cloud Deploy.** we can execute the script deploy.sh. This one will create a simple pipeline with 2 targets


## Architecture.

**Online Boutique** is composed of 11 microservices written in different
languages that talk to each other over gRPC. See the [Development Principles](/docs/development-principles.md) doc for more information.

[![Architecture of
microservices](./docs/img/architecture-diagram.png)](./docs/img/architecture-diagram.png)

Find **Protocol Buffers Descriptions** at the [`./pb` directory](./pb).

| Service                                              | Language      | Description                                                                                                                       |
| ---------------------------------------------------- | ------------- | --------------------------------------------------------------------------------------------------------------------------------- |
| [frontend](./src/frontend)                           | Go            | Exposes an HTTP server to serve the website. Does not require signup/login and generates session IDs for all users automatically. |
| [cartservice](./src/cartservice)                     | C#            | Stores the items in the user's shopping cart in Redis and retrieves it.                                                           |
| [productcatalogservice](./src/productcatalogservice) | Go            | Provides the list of products from a JSON file and ability to search products and get individual products.                        |
| [currencyservice](./src/currencyservice)             | Node.js       | Converts one money amount to another currency. Uses real values fetched from European Central Bank. It's the highest QPS service. |
| [paymentservice](./src/paymentservice)               | Node.js       | Charges the given credit card info (mock) with the given amount and returns a transaction ID.                                     |
| [shippingservice](./src/shippingservice)             | Go            | Gives shipping cost estimates based on the shopping cart. Ships items to the given address (mock)                                 |
| [emailservice](./src/emailservice)                   | Python        | Sends users an order confirmation email (mock).                                                                                   |
| [checkoutservice](./src/checkoutservice)             | Go            | Retrieves user cart, prepares order and orchestrates the payment, shipping and the email notification.                            |
| [recommendationservice](./src/recommendationservice) | Python        | Recommends other products based on what's given in the cart.                                                                      |
| [adservice](./src/adservice)                         | Java          | Provides text ads based on given context words.                                                                                   |
| [loadgenerator](./src/loadgenerator)                 | Python/Locust | Continuously sends requests imitating realistic user shopping flows to the frontend.                                              |
