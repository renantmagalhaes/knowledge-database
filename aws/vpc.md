# VPC

# Subnet

* For stage envs
```
172.31.0.0/18
172.31.64.0/18
172.31.128.0/18
```

* For production envs
```
10.1.0.0/18
10.1.64.0/18
10.1.128.0/18
```

# Internet Gateway

vpcname-igw 

```Create > Attach```


# Routes

1. Create
2. Associate Subnet
3. Edit route (0.0.0.0/0 to internet gateway)