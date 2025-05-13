$DOTFILES_REPO = "https://github.com/QuantumSpawner/.dotfiles"
$DOTFILES_HOME = "$env:UserProfile"
$DOTFILES_DIR = "$DOTFILES_HOME\.dotfiles"

$CONFIG_FILE = "$DOTFILES_DIR/windows/config.json"

if (-not ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
    Write-Host "Restarting script with administrator privileges..."
    Start-Process powershell -ArgumentList "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
    exit
}

if (-not (Test-Path $DOTFILES_DIR)) {
    git clone $DOTFILES_REPO $DOTFILES_DIR
} else {
    Push-Location $DOTFILES_DIR
    git pull
    Pop-Location
}

$config = Get-Content $CONFIG_FILE | ConvertFrom-Json
foreach ($entry in $config) {
    New-Item -Path "$DOTFILES_HOME\$($entry.dst)" -Value "$DOTFILES_DIR\$($entry.src)" -ItemType SymbolicLink -Force
}

Pause
