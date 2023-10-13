# coatl-dev GitHub Actions

[![ci](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml/badge.svg)](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml)

A collection of custom GitHub Actions that are used to simplify our pipelines
in projects to keep them DRY.

## Catalog

- [gpg-import](#gpg-import)
- [pip-compile/2.7](#pip-compile27)
- [pip-compile/3.11](#pip-compile311)
- [simple-git-diff](#simple-git-diff)

### gpg-import

GitHub Action to import GPG private key.

**Inputs**:

- `config-git` (`string`): Whether to config Git to sign commits with the
  information obtained from GPG. Options: `'yes'`, `'no'`. Defaults to `'yes'`.
  Optional.
- `passphrase` (`secret`): GPG private key passphrase. Required.
- `private-key` (`secret`): GPG private key exported as an ASCII
  armored version. Required.

**Outputs**:

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
        uses: coatl-dev/actions/gpg-import@v0.3.0
        with:
          passphrase: ${{ secrets.GPG_PASSPHRASE }}
          private-key: ${{ secrets.GPG_PRIVATE_KEY }}

      - name: Make changes
        run: |
            # Your changes go here

      - name: Sign commit
        run: |
          # Creates a signed commit
          git commit -m "YOUR_COMMIT_MESSAGE"
```

### pip-compile/2.7

Run `pip-compile` to upgrade your Python 2 requirements.

> The `pip-compile` command lets you compile a `requirements.txt` file from your
dependencies, specified in either `setup.py` or `requirements.in`.

**Notes**:

- :information_source: This essentially installs [`pip-tools==5.5.0`], which was
  the last release supporting Python 2.

**Inputs**:

- `path` (`string`): A file or location of the requirement file(s).

**Example**:

```yml
name: pip-compile-27

on:
  schedule:
    # Monthly at 12:00 PST (00:00 UTC)
    - cron: '0 20 1 * *'

jobs:
  pip-compile:
    runs-on: ubuntu-latest
    env:
      REQUIREMENTS_PATH: 'path/to/requirements'

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: pip-compile-27
        uses: coatl-dev/actions/pip-compile/2.7@v0.3.0
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"

      - name: Detect changes
        id: git-diff
        uses: coatl-dev/actions/simple-git-diff@v0.3.0
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"

      - name: Do something if changes were made
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

### pip-compile/3.11

Run pip-compile to upgrade your Python 3 requirements.

> The `pip-compile` command lets you compile a `requirements.txt` file from your
dependencies, specified in either `pyproject.toml`, `setup.cfg`, `setup.py`, or
`requirements.in`.

**Inputs**:

- `path` (`string`): A file or location of the requirement file(s).

**Example**:

```yml
name: pip-compile-311

on:
  schedule:
    # Monthly at 12:00 PST (00:00 UTC)
    - cron: '0 20 1 * *'

jobs:
  pip-compile:
    runs-on: ubuntu-latest
    env:
      REQUIREMENTS_PATH: 'path/to/requirements'

    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: pip-compile-311
        uses: coatl-dev/actions/pip-compile/3.11@v0.3.0
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"

      - name: Detect changes
        id: git-diff
        uses: coatl-dev/actions/simple-git-diff@v0.3.0
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"

      - name: Do something if changes were made
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

### simple-git-diff

Run [`git diff`] on a file or path.

**Inputs**:

- `path` (`string`): File or path to check for changes. Defaults to `'.'`.
  Optional.

**Outputs**:

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
        uses: coatl-dev/actions/simple-git-diff@v0.3.0
        with:
          path: 'README.md'

      - name: Do something if changes were detected
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

[`git diff`]: https://git-scm.com/docs/git-diff
[`pip-tools==5.5.0`]: https://pypi.org/project/pip-tools/5.5.0/
