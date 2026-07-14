- [REGEX](#regex)
  - [Sed](#sed)
    - [Add text in the first line of an archive](#add-text-in-the-first-line-of-an-archive)
  - [Grep](#grep)
    - [Extract email addresses from CSV](#extract-email-addresses-from-csv)
    - [Count rows matching a field](#count-rows-matching-a-field)
  - [Awk](#awk)
    - [Print selected CSV columns](#print-selected-csv-columns)
  - [JQ](#jq)
    - [Extract JSON fields](#extract-json-fields)
  - [Python](#python)
    - [Search YAML keys by regex](#search-yaml-keys-by-regex)

# REGEX

## Sed

#### Add text in the first line of an archive
```
sed -e '1i value1,value2,value3,value4\' csv_1.csv
```

## Grep

#### Extract email addresses from CSV
```
grep -Eo '[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}' csv_1.csv
```

#### Count rows matching a field
```
grep -E ',China,' csv_1.csv | wc -l
```

## Awk

#### Print selected CSV columns
```
awk -F, 'NR==1 || /China/ { print $1","$4","$5 }' csv_1.csv
```

## JQ

#### Extract JSON fields
```
jq -r '.[] | [.name, .email] | @csv' json_1.json
```

## Python

#### Search YAML keys by regex
```
python3 -c "import re, pathlib; text=pathlib.Path('yaml_1.yaml').read_text(); print(re.findall(r'^\s*name:\s*(.+)', text, re.M))"
```

## Notes

- `grep` is useful for quick pattern matching in plain text files.
- `awk` is useful for field extraction and quick reporting from delimited data.
- `jq` is the most reliable tool for structured JSON extraction.
- Use `python3` when you need richer regex handling or multi-line searches.
