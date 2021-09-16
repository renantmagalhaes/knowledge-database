# CORS

# Enable CORS (domains)

```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "HEAD"
        ],
        "AllowedOrigins": [
            "https://sub.domain.com",
            "https://*.domain.com",
            "http://localhost:3000"
        ],
        "ExposeHeaders": [
            "Content-Type",
            "x-amz-request-id",
            "Cache-Control"
        ],
        "MaxAgeSeconds": 3000
    }
]
```