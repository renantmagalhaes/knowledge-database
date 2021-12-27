# Logging Solutions

* Obs: May be necessary attach the Cloud Watch IAM policy inside the EKS NodeGroup

# FluentD + CloudWatch + ElasticSearch


## Configure FluentD

Change this values inside the **fluentd.yml** file

```
      containers:
      - name: fluentd-cloudwatch
        image: fluent/fluentd-kubernetes-daemonset:v1.14-debian-cloudwatch-1
        env:
          - name: REGION
            value: eu-west-1
          - name: CLUSTER_NAME
            value: EKS-Workshop
```

Apply **fluentd.yml**.

```
kubectl apply -f fluentd/fluentd.yml
```

Logs can take up to 5 minutes before showing inside CloudWatch

```
AWS -> CloudWatch -> Logs -> Log Groups -> /eks/EKS-Workshop/containers
```

Better way to visualize

1. Enter in the Log Events
2. Actions
3. Expamd all rows

# Create Elastic Search Stack

-Under Construction-

## Configure CloudWatch

* Create a new role (IAM)

1. Roles
2. Create Role
3. Select Lambda
4. Next: Permissions
5. Attach AmazonESFullAccess
6. rolename -> lambda_es

* Go to cloudwatch /eks/EKS-Workshop/containers

1. Actions
2. Create Amazon OpenSearch Service subscription filter
3. Select Amazon ES cluster
4. Select Lambda IAM execution Role (lambda_es)
5. Log format -> Common Log Format
6. Subscription filter name ->  [^:*]*
7. Start Streaming

* Open Kibana

- Auth
1. Security
2. Roles
3. all_access
4. Mapped users
5. Manage mapping
6. Add user (edit arn as needed):
   1. arn:aws:iam::111111111111:role/lambda_es
7. Add backend roles
   1. arn:aws:iam::111111111111:role/lambda_es

- Index
1. Dashboard
2. Create Index Pattern
3. cwl-*
4. Next step
5. @timestamp
6. Create Index pattern

# Demo

```
kubectl apply -f log-generator/log-generator.yml
```