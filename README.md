# coatl-dev GitHub Actions

[![ci](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml/badge.svg)](https://github.com/coatl-dev/actions/actions/workflows/ci.yaml)

A collection of custom GitHub Actions that are used to simplify our pipelines
in projects to keep them DRY.

## Catalog

- [gpg-import](#gpg-import)
- [pip-compile](#pip-compile)
- [pr-create](#pr-create)
- [pre-commit-autoupdate](#pre-commit-autoupdate)
- [pypi-upload](#pypi-upload)
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
        uses: coatl-dev/actions/gpg-import@v0.9.5
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
        uses: coatl-dev/actions/pip-compile@v0.9.5
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"
          python-version: '2.7.18'

      - name: Detect changes
        id: git-diff
        uses: coatl-dev/actions/simple-git-diff@v0.9.5
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"

      - name: Do something if changes were made
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

### pr-create

GitHub Action to create Pull Request using gh.

**Inputs**:

- `gh-token` (`secret`): GitHub token. Required.
- `title` (`string`): Title for the pull request. Optional.
- `body` (`string`): Body for the pull request. Optional.
- `body-file` (`string`): Read body text from file. Optional.

**Notes**:

If all optional inputs are missing, `gh` will use the commit message and body
and run `gh pr create --fill`.

**Example**:

Add this step to your workflow:

```yml
      - name: Create Pull Request
        uses: coatl-dev/actions/pr-create@v0.9.5
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
        uses: coatl-dev/actions/pre-commit-autoupdate@v0.9.5
        with:
          gh-token: ${{ secrets.GH_TOKEN }}
          gpg-sign-passphrase: ${{ secrets.GPG_PASSPHRASE }}
          gpg-sign-private-key: ${{ secrets.GPG_PRIVATE_KEY }}
          skip-repos: 'flake8'
```

### pypi-upload

GitHub action for building and publishing your Python 2/2 distribution files to
PyPI or any other repository using `build` and `twine`.

**Inputs**:

- `python-version` (`string`): Python version to use for building your
  distribution package. You may use MAJOR.MINOR or exact version. Defaults to
  `'2.7'`. Optional.
- `username` (`string`): Defaults to `'__token__'`. Optional.
- `password`: (`string`). It can be a password or token. Required. Note: It is
  recommended to keep your password as secrets.
- `url` (`string`): The repository (package index) URL to upload the package to.
  Defaults to `'https://upload.pypi.org/legacy/'`. Optional.
- `check` (`string`): Checks whether your distribution’s long description will
  render correctly on PyPI. Defaults to `'yes'`. Options: `'yes'`, `'no'`.
  Optional.
- `upload` (`string`): Uploads to a repository. Defaults to `'yes'`. Options:
  `'yes'`, `'no'`. Optional.

**Example**:

To use this action, add the following step to your workflow file (e.g.
`.github/workflows/publish.yaml`).

```yml
name: publish

on:
  release:
    types:
      - published

jobs:
  pypi-publish:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout repo
        uses: actions/checkout@v4

      - name: python-pypi-upload
        uses: coatl-dev/actions/pypi-upload@v0.9.5
        with:
          password: ${{ secrets.PYPI_API_TOKEN }}
          python-version: '3.11'
```

**Uploading to TestPyPI**:

```yml
- name: Publish package to TestPyPI
  uses: coatl-dev/actions/pypi-upload@v1
  with:
    username: ${{ secrets.TEST_PYPI_USER }}
    password: ${{ secrets.TEST_PYPI_API_TOKEN }}
    url: "https://test.pypi.org/legacy/"
```

**Disabling metadata verification**:

It is recommended that you run `twine check` before upload. You can also disable
it with:

```yml
   with:
     check: no
```

**Disabling automatically uploading the package**:

If you would like to run additional checks before uploading, you can disable it
with:

```yml
   with:
     upload: no
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
        uses: coatl-dev/actions/simple-git-diff@v0.9.5
        with:
          path: 'README.md'

      - name: Do something if changes were detected
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

[`git diff`]: https://git-scm.com/docs/git-diff
[`local hooks`]: https://pre-commit.com/#repository-local-hooks
[`pip-tools==5.5.0`]: https://pypi.org/project/pip-tools/5.5.0/
[Temporarily disabling hooks]: https://pre-commit.com/#temporarily-disabling-hooks
