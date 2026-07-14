# Strip CRLF From Command Output

Useful on Windows/WSL where trailing `\r\n` breaks downstream parsing.

```sh
curl ipinfo.io/ip | tr -d "\n\r"
```
