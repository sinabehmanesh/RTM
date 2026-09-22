$ErrorActionPreference = 'Stop'

$MinGitVersion = [version]'2.20.0'
$MinGoVersion = [version]'1.22.5'
$IsWindowsHost = $env:OS -eq 'Windows_NT'

function Require-Command {
    param([string]$Name)

    if (-not (Get-Command $Name -ErrorAction SilentlyContinue)) {
        throw "Error: '$Name' is required but was not found in PATH."
    }
}

Require-Command git
Require-Command go

$gitOutput = (& git --version)
if ($gitOutput -notmatch 'git version (\d+(?:\.\d+){1,2})') {
    throw "Error: Could not determine the installed Git version."
}
$GitVersion = [version]$Matches[1]

$goOutput = (& go version)
if ($goOutput -notmatch 'go version go(\d+(?:\.\d+){1,2})') {
    throw "Error: Could not determine the installed Go version."
}
$GoVersion = [version]$Matches[1]

if ($GitVersion -lt $MinGitVersion) {
    throw "Error: Git $MinGitVersion or newer is required. Found Git $GitVersion."
}

if ($GoVersion -lt $MinGoVersion) {
    throw "Error: Go $MinGoVersion or newer is required. Found Go $GoVersion."
}

if ($env:RTM_INSTALL_DIR) {
    $InstallRoot = $env:RTM_INSTALL_DIR
} elseif ($IsWindowsHost) {
    $InstallRoot = Join-Path $env:LOCALAPPDATA 'RTM'
} else {
    $InstallRoot = Join-Path $HOME '.local/share/rtm'
}

$SourceDir = Join-Path $InstallRoot 'source'

if ($env:RTM_BIN_DIR) {
    $BinDir = $env:RTM_BIN_DIR
} elseif ($IsWindowsHost) {
    $BinDir = Join-Path $InstallRoot 'bin'
} else {
    $BinDir = Join-Path $HOME '.local/bin'
}

$BinaryName = if ($IsWindowsHost) { 'rtm.exe' } else { 'rtm' }
$Binary = Join-Path $BinDir $BinaryName
$TempBinary = Join-Path $BinDir ".rtm-update-$PID"

if (-not (Test-Path (Join-Path $SourceDir '.git'))) {
    throw "Error: RTM installation was not found at '$SourceDir'. Run the RTM installer first, then run the updater again."
}

New-Item -ItemType Directory -Path $BinDir -Force | Out-Null

try {
    Write-Host 'Updating RTM source...'
    & git -C $SourceDir fetch --depth 1 origin main
    if ($LASTEXITCODE -ne 0) {
        throw 'Git fetch failed.'
    }

    & git -C $SourceDir checkout -B main origin/main
    if ($LASTEXITCODE -ne 0) {
        throw 'Git checkout failed.'
    }

    Write-Host 'Building latest RTM...'
    Push-Location $SourceDir
    try {
        & go build -o $TempBinary .
        if ($LASTEXITCODE -ne 0) {
            throw 'Go build failed.'
        }
    } finally {
        Pop-Location
    }

    Move-Item -Force $TempBinary $Binary

    if (-not $IsWindowsHost) {
        & chmod +x $Binary
        if ($LASTEXITCODE -ne 0) {
            throw 'Could not mark the RTM binary as executable.'
        }
    }

    Write-Host "RTM updated: $Binary"
} finally {
    if (Test-Path $TempBinary) {
        Remove-Item -Force $TempBinary
    }
}
