# coatl-dev GitHub Actions

[![ci](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml/badge.svg)](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml)

A collection of custom GitHub Actions that are used to simplify our pipelines
in projects to keep them DRY.

## Catalog

- [gpg-import](#gpg-import)
- [pip-compile](#pip-compile)
- [pip-compile-upgrade](#pip-compile-upgrade)
- [pr-create](#pr-create)
- [pre-commit-autoupdate](#pre-commit-autoupdate)
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
        uses: coatl-dev/actions/gpg-import@v1.2.1
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

### pip-compile

Run `pip-compile` to upgrade your Python 2/3 requirements.

For Python 2:

> The `pip-compile` command lets you compile a `requirements.txt` file from your
dependencies, specified in either `setup.py` or `requirements.in`.

For Python 3:

> The `pip-compile` command lets you compile a `requirements.txt` file from your
dependencies, specified in either `pyproject.toml`, `setup.cfg`, `setup.py`, or
`requirements.in`.

**Notes**:

- :information_source: This action will install the latest release for
  `pip-tools` supporting your choice for `python-version`. E.g., for Python
  `'2.7'`, it will install [`pip-tools==5.5.0`].

**Inputs**:

- `path` (`string`): A file or location of the requirement file(s).
- `python-version` (`string`): Python version to use for installing `pip-tools`.
  You may use MAJOR.MINOR or exact version. Defaults to `'2.7'`. Optional.

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
        uses: coatl-dev/actions/pip-compile@v1.2.1
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"
          python-version: '2.7.18'

      - name: Detect changes
        id: git-diff
        uses: coatl-dev/actions/simple-git-diff@v1.2.1
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"

      - name: Do something if changes were made
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

### pip-compile-upgrade

GitHub action for running `pip-compile upgrade` on your Python 2 and 3
requirements.

**Inputs**:

- `path` (`string`): A file or location of the requirement file(s).
- `python-version` (`string`): Python version to use for installing `pip-tools`.
  You may use MAJOR.MINOR or exact version. Defaults to `'2.7'`. Optional.
- `gh-token` (`secret`): GitHub token. Required.
- `gpg-sign-passphrase` (`secret`): GPG private key passphrase. Required when
  signing commits, otherwise is optional.
- `gpg-sign-private-key` (`secret`): GPG private key exported as an ASCII
  armored version. Required when signing commits, otherwise is optional.
- `pr-base-branch` (`string`): The branch into which you want your code merged.
  Defaults to `'main'`. Required when `pr-create` is set to `'yes'`, otherwise
  is optional.
- `pr-create` (`string`): Whether to create a Pull Request. Options: `'yes'`,
  `'no'`. Defaults to `'yes'`. Optional.
- `pr-commit-message` (`string`): Use the given message as the commit message.
  Defaults to `'chore(requirements): pip-compile upgrade'`. Optional.
- `pr-auto-merge` (`string`): Automatically merge only after necessary
  requirements are met. Options: `'yes'`, `'no'`. Defaults to `'yes'`. Optional.

**Outputs**:

- `update-hit` (`boolean`): A boolean value to indicate if one or more repos
  were updated.

**Example**:

```yml
name: pip-compile-upgrade

on:
  schedule:
    # Monday at 12:00 PST
    - cron: '0 20 * * 1'
  workflow_dispatch:

jobs:
  pip-compile-upgrade:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Upgrade pip requirements
        uses: coatl-dev/actions/pip-compile-upgrade@v1.2.1
        with:
          path: requirements
          gh-token: ${{ secrets.GH_TOKEN }}
          gpg-sign-passphrase: ${{ secrets.GPG_PASSPHRASE }}
          gpg-sign-private-key: ${{ secrets.GPG_PRIVATE_KEY }}
```

### pr-create

GitHub Action to create Pull Request using gh.

**Inputs**:

- `gh-token` (`secret`): GitHub token. Required.
- `title` (`string`): Title for the pull request. Optional.
- `body` (`string`): Body for the pull request. Optional.
- `body-file` (`string`): Read body text from file. Optional.
- `auto-merge` (`string`): Automatically merge only after necessary requirements
  are met. Options: `'yes'`, `'no'`. Defaults to `'yes'`. Optional.

**Notes**:

If all optional inputs are missing, `gh` will use the commit message and body
and run `gh pr create --fill`.

**Example**:

Add this step to your workflow:

```yml
      - name: Create Pull Request
        uses: coatl-dev/actions/pr-create@v1.2.1
        with:
          gh-token: ${{ secrets.GH_TOKEN }}
```

### pre-commit-autoupdate

GitHub action for running `pre-commit autoupdate` and allow to skip hooks.

**Inputs**:

- `cache` (`string`): Whether to enable caching. Options: `'yes'`, `'no'`.
  Defaults to `'yes'`. Optional.
- `gh-token` (`secret`): GitHub token. Required.
- `gpg-sign-passphrase` (`secret`): GPG private key passphrase. Required when
  signing commits, otherwise is optional.
- `gpg-sign-private-key` (`secret`): GPG private key exported as an ASCII
  armored version. Required when signing commits, otherwise is optional.
- `pr-base-branch` (`string`): The branch into which you want your code merged.
  Defaults to `'main'`. Required when `pr-create` is set to `'yes'`, otherwise
  is optional.
- `pr-create` (`string`): Whether to create a Pull Request. Options: `'yes'`,
  `'no'`. Defaults to `'yes'`. Optional.
- `pr-auto-merge` (`string`): Automatically merge only after necessary
  requirements are met. Options: `'yes'`, `'no'`. Defaults to `'yes'`. Optional.
- `skip-repos` (`string`): A list of repos to exclude from autoupdate. The repos
  must be separated by a "pipe" character `'|'`. Defaults to `''`. Optional.

**Outputs**:

- `update-hit` (`boolean`): A boolean value to indicate if one or more repos
  were updated.

**Example**:

```yml
name: pre-commit-autoupdate

on:
  schedule:
    # Monday at 12:00 PST
    - cron: '0 20 * * 1'
  workflow_dispatch:

jobs:
  pre-commit-autoupdate:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: Update pre-commit hooks
        uses: coatl-dev/actions/pre-commit-autoupdate@v1.2.1
        with:
          gh-token: ${{ secrets.GH_TOKEN }}
          gpg-sign-passphrase: ${{ secrets.GPG_PASSPHRASE }}
          gpg-sign-private-key: ${{ secrets.GPG_PRIVATE_KEY }}
          skip-repos: 'flake8'
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
        uses: coatl-dev/actions/simple-git-diff@v1.2.1
        with:
          path: 'README.md'

      - name: Do something if changes were detected
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

[`git diff`]: https://git-scm.com/docs/git-diff
[`pip-tools==5.5.0`]: https://pypi.org/project/pip-tools/5.5.0/
