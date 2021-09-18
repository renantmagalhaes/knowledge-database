# Install some missing packages
```
apt-get install pulseaudio pulseaudio-module-bluetooth pavucontrol bluez-firmware blueman
```

# Set config

```
echo "AutoConnect=true" >> /etc/bluetooth/main.conf
```

# Restart service

```service bluetooth restart```

# Kill pulseaudio

```killall pulseaudio```


# Fix a2dp profile

```
touch /etc/pulse/client.conf
cat <<EOF >> /etc/pulse/client.conf
autospawn = no
daemon-binary = /bin/true
EOF

chown Debian-gdm:Debian-gdm /etc/pulse/client.conf

rm /etc/pulse/.config/systemd/user/sockets.target.wants/pulseaudio.socket

echo "load-module module-switch-on-connect" >> /etc/pulse/default.pa
```

and reboot

# Run pavucontrol as root

```sudo pavucontrol```

And do to Output > Show "All Output Devices" > Select A2DP
