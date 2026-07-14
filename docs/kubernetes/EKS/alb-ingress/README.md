# Ingress

Types of Ingress

- Nginx
- Traefik
- **AWS ALB (Application Load Balancer)**

# ALB

## Deploy Policies, RBAC roles and role bindings as required by the AWS ALB Ingress controller

```
curl -o iam_policy.json https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.3.0/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json
```

Copy the output

```
{
    "Policy": {
        "PolicyName": "AWSLoadBalancerControllerIAMPolicy",
        "PolicyId": "ANPAWNZ5M62OL7KUFQUXP",
        "Arn": "arn:aws:iam::111111111111:policy/AWSLoadBalancerControllerIAMPolicy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-12-18T19:50:30+00:00",
        "UpdateDate": "2021-12-18T19:50:30+00:00"
    }
}
```

And edit the values as needed

```
eksctl create iamserviceaccount \
  --cluster=EKS-Workshop \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --attach-policy-arn=arn:aws:iam::111111111111:policy/AWSLoadBalancerControllerIAMPolicy \
  --override-existing-serviceaccounts \
  --approve
```

## Cert Manager

Edit as needed

--set image.repository=**account**.dkr.ecr.**region-code**.amazonaws.com/amazon/aws-load-balancer-controller

https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html


```
helm repo add eks https://aws.github.io/eks-charts
helm repo update

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=EKS-Workshop \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon/aws-load-balancer-controller
```

### Upgrade Cert Manager

The deployed chart doesn't receive security updates automatically. You need to manually upgrade to a newer chart when it becomes available. When upgrading, change install to upgrade in the previous command, but run the following command to install the TargetGroupBinding custom resource definitions before running the previous command.

```
kubectl apply -k "github.com/aws/eks-charts/stable/aws-load-balancer-controller/crds?ref=master"

helm upgrade aws-load-balancer-controller eks/aws-load-balancer-controller \
  -n kube-system \
  --set clusterName=EKS-Workshop \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set image.repository=602401143452.dkr.ecr.eu-west-1.amazonaws.com/amazon/aws-load-balancer-controller

```

# Create certificate for EKS domain ACM

## Demo

- Create namespace

```
kubectl apply -f files/0-namespace.yml
```

- Create Deployments

```
kubectl apply -f files/1-2048-game.yml
 kubectl apply -f files/2-nginx.yaml
```

- Edit nginx folder
  
1. Enter on nginx container 
2. Create frontend and backend on html folder
3. Copy index.html to these folders
4. Edit the content of index.html


- Create ingress file

```
kubectl apply -f files/ingress.yml
```

## Add ingress to route53

```
kgi -n ingress-demo

NAME           CLASS    HOSTS   ADDRESS                                                                 PORTS   AGE
ingress-demo   <none>   *       k8s-ingressd-ingressd-1a1a1a1a1a-31671003.eu-west-1.elb.amazonaws.com   80      5
```

1. Create record with **domainname.com**
2. Record type A
3. Enable Alias
4. Route Traffic
   1. Alias to application and classic load balancer
   2. region
   3. loadbalancer name

1. Create record with **www.domainname.com**
2. Record type CNAME
3. Enable Alias
4. Alias to another record in this hosted zone
5. Select record above