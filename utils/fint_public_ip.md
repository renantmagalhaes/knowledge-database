# Find public IP

# Fast discover

```curl ipinfo.io/ip```

# Slow discover

```curl ifconfig.me```


# benchmark
```
time curl ipinfo.io/ip
real	0m0,300s
user	0m0,004s
sys	0m0,007s

time curl ifconfig.me
real	0m16,288s
user	0m0,006s
sys	0m0,00
```