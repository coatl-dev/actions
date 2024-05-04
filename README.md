# coatl-dev GitHub Actions

[![pre-commit.ci status](https://results.pre-commit.ci/badge/github/coatl-dev/actions/coatl.svg)](https://results.pre-commit.ci/latest/github/coatl-dev/actions/coatl)

A collection of custom GitHub Actions that are used to simplify our pipelines
in projects to keep them DRY.

## Catalog

- [gpg-import](#gpg-import)
- [pip-compile](#pip-compile)
- [pr-create](#pr-create)
- [setup-jython](#setup-jython)
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
        uses: coatl-dev/actions/gpg-import@v3.3.0
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

The `pip-compile` command lets you compile a `requirements.txt` file from your
dependencies, specified in either `setup.py` or `requirements.in`.

For Python 3:

The `pip-compile` command lets you compile a `requirements.txt` file from your
dependencies, specified in either `pyproject.toml`, `setup.cfg`, `setup.py`, or
`requirements.in`.

**Inputs**:

- `path` (`string`): A file or location of the requirement file(s).
- `working-directory` (`string`): Useful when the path input is a file inside a
  directory.
- `python-version` (`string`): Python version to use for installing `pip-tools`.
  You may use MAJOR.MINOR or exact version. Defaults to `'3.12'`. Optional.

> [!NOTE]
> This action will install the latest release for `pip-tools` supporting your
> choice for `python-version`. E.g., for Python `'2.7'`, it will install
> [`pip-tools==5.5.0`].

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
        uses: coatl-dev/actions/pip-compile@v3.3.0
        with:
          path: "${{ env.REQUIREMENTS_PATH }}"
          python-version: '2.7.18'

      - name: Detect changes
        id: git-diff
        uses: coatl-dev/actions/simple-git-diff@v3.3.0
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
- `auto-merge` (`string`): Automatically merge only after necessary requirements
  are met. Options: `'yes'`, `'no'`. Defaults to `'yes'`. Optional.

> [!IMPORTANT]
> If all optional inputs are missing, `gh` will use the commit message and body
> and run `gh pr create --fill`.

**Example**:

Add this step to your workflow:

```yml
      - name: Create Pull Request
        uses: coatl-dev/actions/pr-create@v3.3.0
        with:
          gh-token: ${{ secrets.GH_TOKEN }}
```

### setup-jython

Set up a specific version of Jython and add the command-line tools to the PATH.

> [!TIP]
> This action also sets the `JYTHON_HOME` environment variable.

**Inputs**:

- `jython-version` (`string`): The Jython version to install. Defaults to
  `'2.7.3'`. Optional. See [supported Jython versions].
- `java-distribution` (`string`): Java distribution to use for installing
  Jython. Defaults to `'zulu'`. Optional. See [supported Java distributions].
- `java-version` (`string`): The Java version to set up. Defaults to `'17'`.
  Optional.

**Outputs**:

- `jython-version` (`string`): The installed Jython version.
- `jython-path` (`string`): The absolute path to the Jython executable.
- `java-distribution` (`string`):Distribution of Java that has been installed.
- `java-version` (`string`): Actual version of the java environment that has
  been installed.
- `java-path` (`string`): Path to where the java environment has been installed
  (same as $JAVA_HOME).

**Example**:

```yml
    - name: Set up Jython
      uses: coatl-dev/actions/setup-jython@v3.3.0
      with:
        jython-version: '2.7.3'
    - run: jython my_script.py
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
        uses: coatl-dev/actions/simple-git-diff@v3.3.0
        with:
          path: 'README.md'

      - name: Do something if changes were detected
        if: ${{ steps.git-diff.outputs.diff == 'true' }}
        run: |
          echo "Changes were detected."
```

[`git diff`]: https://git-scm.com/docs/git-diff
[`pip-tools==5.5.0`]: https://pypi.org/project/pip-tools/5.5.0/
[supported Java distributions]: https://github.com/actions/setup-java#supported-distributions
[supported Jython versions]: https://repo1.maven.org/maven2/org/python/jython-installer/
