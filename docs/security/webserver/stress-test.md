# Stress test

## ab

[ab](https://httpd.apache.org/docs/2.4/programs/ab.html) is a tool for benchmarking your Apache Hypertext Transfer Protocol (HTTP) server. It is designed to give you an impression of how your current Apache installation performs. This especially shows you how many requests per second your Apache installation is capable of serving.

### Example

```
ab -n 1000 -c 100 -g l.txt https://website.com/
```
```
-n -> Number of requests to perform for the benchmarking session
-c -> Number of multiple requests to perform at a time. 
-g -> Write all measured values out as a 'gnuplot' or TSV (Tab separate values) file
```

## Siege

[Siege](https://github.com/JoeDog/siege) is an open source regression test and benchmark utility. It can stress test a single URL with a user defined number of simulated users, or it can read many URLs into memory and stress them simultaneously.

### Example

```
siege -c 1024 -d 10 https://www.website.com
```
```
-c -> CONCURRENT users, default is 10
-d -> Time DELAY, random delay before each request
```