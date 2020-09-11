# Fedora

## Commands

### List group of packages
```dnf group list```

### List of all installed packages on the system
```rpm -qa```
#### Search for specific package
```rpm -qa |grep <package_name>```

### Package’s version, description, and other metainformation
```rpm -qi <package_name>```

### Contents of an installed package
```rpm -ql <package_name>```

### Package log information
```rpm -q --changes <packag_name>```
