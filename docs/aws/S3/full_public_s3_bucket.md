# Full public S3 bucket

## Step 1

Turn off Block public access (bucket settings)

1. S3 
2. Permissions
3.  Block public access (bucket settings)
4.  Block all public access 
5.  OFF


## Step 2 

Add Bucket policy

1. S3 
2. Permissions
3. Bucket policy

Edit **BUCKETNAME**

```
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "AddPerm",
            "Effect": "Allow",
            "Principal": "*",
            "Action": "s3:GetObject",
            "Resource": "arn:aws:s3:::BUCKETNAME/*"
        }
    ]
}
```

