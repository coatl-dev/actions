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
