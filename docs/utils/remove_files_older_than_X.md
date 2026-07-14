# Remove Files Older Than X Days

```sh
find /path/to/folder -mtime +10 | xargs rm
```

- `-mtime +10` — files older than 10 days

## Other parameters

- `-size 0` — files with size 0
- `| grep -v pattern` — invert match

## Find file and edit the search

```sh
find path/to/files -mtime +1 -size 0 | grep .downloading | sed -e 's/\.downloading/\*/g' | xargs echo rm | sh
```

Modify the `.downloading` extension to `*` and remove all matches.
