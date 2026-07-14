# EFS

[DOCS](https://docs.aws.amazon.com/eks/latest/userguide/efs-csi.html)

# Create IAM policy and role

```
curl -o iam-policy-example.json https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/v1.3.2/docs/iam-policy-example.json

aws iam create-policy \
    --policy-name AmazonEKS_EFS_CSI_Driver_Policy \
    --policy-document file://iam-policy-example.json
```

output

```
{
    "Policy": {
        "PolicyName": "AmazonEKS_EFS_CSI_Driver_Policy",
        "PolicyId": "ANPAWNZ5M62OLO6A72MZN",
        "Arn": "arn:aws:iam::111111111111:policy/AmazonEKS_EFS_CSI_Driver_Policy",
        "Path": "/",
        "DefaultVersionId": "v1",
        "AttachmentCount": 0,
        "PermissionsBoundaryUsageCount": 0,
        "IsAttachable": true,
        "CreateDate": "2021-12-24T14:07:49+00:00",
        "UpdateDate": "2021-12-24T14:07:49+00:00"
    }
}
```

Annotate the Kubernetes service account with the IAM role ARN and the IAM role with the Kubernetes service account name.

```
eksctl create iamserviceaccount \
    --name efs-csi-controller-sa \
    --namespace kube-system \
    --cluster EKS-Workshop \
    --attach-policy-arn arn:aws:iam::111111111111:policy/AmazonEKS_EFS_CSI_Driver_Policy \
    --approve \
    --override-existing-serviceaccounts \
    --region eu-west-1
```

# Install the Amazon EFS driver

```
helm repo add aws-efs-csi-driver https://kubernetes-sigs.github.io/aws-efs-csi-driver/
helm repo update
```

Install a release of the driver using the Helm chart. Replace the repository address with the [cluster's container image address.](https://docs.aws.amazon.com/eks/latest/userguide/add-ons-images.html)

```
helm upgrade -i aws-efs-csi-driver aws-efs-csi-driver/aws-efs-csi-driver \
    --namespace kube-system \
    --set image.repository=602401143452.dkr.ecr.eu-west-1.amazonaws.com/eks/aws-efs-csi-driver \
    --set controller.serviceAccount.create=false \
    --set controller.serviceAccount.name=efs-csi-controller-sa
```

Validade containers are created without error

```kubectl  get pods -n kube-system |grep efs```


# Create an Amazon EFS file system

Retrieve the VPC ID that your cluster is in and store it in a variable for use in a later step

```
vpc_id=$(aws eks describe-cluster \
    --name EKS-Workshop \
    --query "cluster.resourcesVpcConfig.vpcId" \
    --output text)
```

Retrieve the CIDR range for your cluster's VPC

```
cidr_range=$(aws ec2 describe-vpcs \
    --vpc-ids $vpc_id \
    --query "Vpcs[].CidrBlock" \
    --output text)
```

Create a security group with an inbound rule that allows inbound NFS traffic for your Amazon EFS mount points

```
security_group_id=$(aws ec2 create-security-group \
    --group-name efsEksRule \
    --description "My EFS security group" \
    --vpc-id $vpc_id \
    --output text)
```

Create an inbound rule that allows inbound NFS traffic from the CIDR for your cluster's VPC.

```
aws ec2 authorize-security-group-ingress \
    --group-id $security_group_id \
    --protocol tcp \
    --port 2049 \
    --cidr $cidr_range
```

Create an Amazon EFS file system for your Amazon EKS cluster

```
file_system_id=$(aws efs create-file-system \
    --region eu-west-1 \
    --performance-mode generalPurpose \
    --query 'FileSystemId' \
    --output text)
```

Create mount targets.

- Determine the IDs of the subnets in your VPC and which Availability Zone the subnet is in.

```
aws ec2 describe-subnets \
    --filters "Name=vpc-id,Values=$vpc_id" \
    --query 'Subnets[*].{SubnetId: SubnetId,AvailabilityZone: AvailabilityZone,CidrBlock: CidrBlock}' \
    --output table
```

```
aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-0a5d40ac202e1aa9c \
    --security-groups $security_group_id

aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-0f018e1fe917055e9 \
    --security-groups $security_group_id

aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-0fa72e55cf18f35bb \
    --security-groups $security_group_id

aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-004949435cb30bd11 \
    --security-groups $security_group_id

aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-0fab268b340ca1951 \
    --security-groups $security_group_id

aws efs create-mount-target \
    --file-system-id $file_system_id \
    --subnet-id subnet-0c4ca4aa23425e15f \
    --security-groups $security_group_id
```

# Enable Storage Class

Edit **fileSystemId**
```
curl -o storageclass.yaml https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/examples/kubernetes/dynamic_provisioning/specs/storageclass.yaml

kubectl apply -f storageclass.yaml
```

# Enable PVC

There`s two volumes here, with the name efs-claim and efs-claim-2. 

They can be used separately inside the deployments 

```
kubectl apply -f 0-pvc.yaml
```

# EXTA

Make sure the auto cycle policy is not enabled if you need you data to persist.

# Demo

```
kubectl apply -f 0-pvc.yaml
kubectl apply -f demo/1-nginx-frontend.yaml
kubectl apply -f demo/2-nginx-backend.yaml
```