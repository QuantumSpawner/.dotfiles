# Dotfiles

## Installation

### Linux

For Unix-like systems, setup the dot files and the development environment using dedicated [dev-playbook](https://github.com/QuantumSpawner/dev-playbook).

> [!NOTE]
> The playbook is private.

### Windows

1. Install `git` using `winget` by:

    ```ps1
    winget install --id Git.Git
    ```

2. Due to [Powershell execution policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) not allowing unsigned scripts to run by default, set to `Bypass` to run the script:

    ```ps1
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
    ```

3. Run the script:

    ```ps1
    .\windows\setup.ps1
    ```

#### winget

This repository also contains a `winget` config file for installing the applications. Install them by:

```ps1
winget import .\windows\winget.json
```
