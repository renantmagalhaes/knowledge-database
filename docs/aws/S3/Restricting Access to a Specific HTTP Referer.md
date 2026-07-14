# Restricting Access to a Specific HTTP Referer

Bucket policy that only allows `GetObject`/`GetObjectVersion` requests originating from a given referer.

```json
{
  "Version": "2012-10-17",
  "Id": "http referer policy example",
  "Statement": [
    {
      "Sid": "Allow get requests originating from www.example.com and example.com.",
      "Effect": "Allow",
      "Principal": "*",
      "Action": ["s3:GetObject", "s3:GetObjectVersion"],
      "Resource": "arn:aws:s3:::awsexamplebucket1/*",
      "Condition": {
        "StringLike": { "aws:Referer": ["http://www.example.com/*", "http://example.com/*"] }
      }
    }
  ]
}
```
