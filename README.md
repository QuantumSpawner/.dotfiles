# Dotfiles

## Installation

### Linux

For Unix-like systems, setup the dot files and the development environment using dedicated [dev-playbook](https://github.com/QuantumSpawner/dev-playbook).

> [!NOTE]
> The playbook is private.

### Windows

1. Prerequisites:

    - git

2. Due to [Powershell execution policy](https://learn.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_execution_policies) not allowing unsigned scripts to run by default, set to `Bypass` to run the script:

    ```ps1
    Set-ExecutionPolicy -ExecutionPolicy Bypass -Scope CurrentUser
    ```
3. Run the script:

    ```ps1
    .\windows\setup.ps1
    ```
