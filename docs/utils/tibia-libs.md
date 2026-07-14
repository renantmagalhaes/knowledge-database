# Tibia Launcher Missing Libs (Linux)

```sh
# Install dependencies
sudo apt-get install openssl libssl1.0-dev libssl1.0-dev libpcre16-3
sudo ln -s /usr/lib/x86_64-linux-gnu/libpcre16.so.3 /usr/lib/x86_64-linux-gnu/libpcre16.so.0

# Copy lib next to the launcher
cp /usr/lib/x86_64-linux-gnu/libpcre16.so.0 .

sudo ./start-tibia-launcher.sh
```
