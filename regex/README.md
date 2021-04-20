- [REGEX](#regex)
  - [Sed](#sed)
      - [Add text in the first line of an archive](#add-text-in-the-first-line-of-an-archive)

# REGEX

## Sed

#### Add text in the first line of an archive
```
sed -e '1i value1,value2,value3,value4\' csv_1.csv
```