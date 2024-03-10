## v3.0.1 (2024-03-09)

### Refactor

- **pip-compile**: default python-version to 3.12 (#49)

## v3.0.0 (2024-03-06)

### BREAKING CHANGE

- default to Python 3.12

### Refactor

- **pip-compile**: default to Python 3.12 (#47)

## v2.0.0 (2024-01-09)

### Refactor

- drop pip-compile-upgrade and pre-commit-autoupdate (#44)

## v1.2.1 (2023-12-11)

### Refactor

- **deps**: update actions/setup-python to version 5 (#42)

## v1.2.0 (2023-11-27)

### Feat

- add pip-compile-upgrade (#39)

## v1.1.0 (2023-11-27)

### Feat

- **pr-create**: add ability to automatically merge PRs (#38)

## v1.0.0 (2023-11-21)

### Refactor

- **pre-commit-autoupdate**: use coatl-dev/workflow-requirements (#37)

## v0.10.1 (2023-11-17)

### Refactor

- **pre-commit-autpupdate**: pip-compile autoupdate (#36)

## v0.10.0 (2023-10-28)

### Refactor

- **pypi-upload**: remove action (#31)

## v0.9.5 (2023-10-27)

### Refactor

- **pypi-upload**: add python-version input (#29)

## v0.9.4 (2023-10-25)

### Refactor

- **pypi-upload**: remove requirement files (#27)

## v0.9.3 (2023-10-24)

### Refactor

- **pre-commit-autoupdate**: remove leading white spaces (#25)

## v0.9.2 (2023-10-24)

### Refactor

- **pre-commir-autoupdate**: generate commit message (#24)

## v0.9.1 (2023-10-23)

### Fix

- **pre-commit-autoupdate**: prevent false positives (#23)

## v0.9.0 (2023-10-23)

### BREAKING CHANGE

- delete pip-compile-2.7 and 3.11

### Refactor

- merge pip-compile 2.7 and 3.11 (#21)

## v0.8.0 (2023-10-20)

### BREAKING CHANGE

- create-pr is now pr-create

### Refactor

- **pr-create**: rename action (#20)

## v0.7.0 (2023-10-20)

### BREAKING CHANGE

- remove skip-hooks input

### Refactor

- **pre-commit-autoupdate**: delete pre-commit run step (#19)

## v0.6.0 (2023-10-16)

### Feat

- add pypi-upload (#18)

## v0.5.1 (2023-10-16)

### Fix

- **pip-compile**: use INPUT_PATH when processing a file (#17)

## v0.5.0 (2023-10-16)

### BREAKING CHANGE

- rename and move pip-compile 2.7 and 3.11 actions

### Refactor

- pip-compile 3.11 autoupdate (#16)
- **pip-compile**: move actions to root directory (#15)

## v0.4.0 (2023-10-16)

### Feat

- add pre-commit-autoupdate (#13)
- add create-pr action (#12)

### Fix

- **pre-commit-autoupdate**: use commit message as title (#14)

## v0.3.0 (2023-10-12)

### BREAKING CHANGE

- move pip-compile Dockerfile into pip-compile/2.7

### Feat

- **pip-compile**: split into 2.7 and 3.11 (#7)

### Fix

- **pip-compile**: fix grep command (#9)

## v0.2.0 (2023-10-12)

### BREAKING CHANGE

- rename file-or-path to path

### Feat

- add pip-compile action (#5)

### Refactor

- **simple-git-diff**: rename input (#2)

## v0.1.0 (2023-10-11)

### Feat

- initial commit
