# coatl-dev GitHub Actions

[![ci](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml/badge.svg)](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml)

A collection of custom GitHub Actions that are used to simplify our pipelines
in projects to keep them DRY.

## Catalog

PLACEHOLDER

### gpg-import

GitHub Action to import GPG private key.

#### Inputs

- `config-git` (`string`): Whether to config Git to sign commits with the
  information obtained from GPG. Options: `'yes'`, `'no'`. Defaults to `'yes'`.
  Optional.
- `passphrase` (`secret`): GPG private key passphrase. Required.
- `private-key` (`secret`): GPG private key exported as an ASCII
  armored version. Required.

#### Outputs

- `git-user-email` (`string`): Email address used for setting up Git identity.
- `git-user-name` (`string`): Name used for setting up Git identity.
- `gpg-key-id` (`string`): The long form of the GPG key ID.

**Example**:

```yml
name: sign-commit

on:
  push:
    branches:
      - main

jobs:
  sign-commit:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Import GPG key
        id: gpg-import
        uses: coatl-dev/actions/gpg-import@v0.0.0
        with:
          passphrase: ${{ secrets.GPG_PASSPHRASE }}
          private-key: ${{ secrets.GPG_PRIVATE_KEY }}

      - name: Sign commit and push changes
        run: |
          echo foo > bar.txt
          git add .
          git commit -S -m "This commit is signed!"
          git push
```

### simple-git-diff

Run git diff on a file or path.

#### Inputs

- `file-or-path` (`string`): File or path to check for changes. Defaults to
  `'.'`. Optional.

#### Outputs

- `diff` (`string`): Whether files were changed between commits. Returns:
  `'true'` or `'false'`.

**Example**:

```yml
name: git-diff

on:
  push:
    branches:
      - main

jobs:
  sign-commit:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Modify file in repo
        run: |
          echo "New line" >> README.md

      - name: Detect changes
        id: git-diff
        uses: coatl-dev/actions/simple-git-diff@v0.0.0
        with:
          file-or-path: 'README.md'

      - name: Sign commit and push changes
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```
