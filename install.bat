@echo off
setlocal

set "REPO_URL=https://github.com/sinabehmanesh/RTM.git"
if defined RTM_REPO_URL set "REPO_URL=%RTM_REPO_URL%"

set "INSTALL_ROOT=%LOCALAPPDATA%\RTM"
if defined RTM_INSTALL_DIR set "INSTALL_ROOT=%RTM_INSTALL_DIR%"

set "SOURCE_DIR=%INSTALL_ROOT%\source"
set "BIN_DIR=%INSTALL_ROOT%\bin"
if defined RTM_BIN_DIR set "BIN_DIR=%RTM_BIN_DIR%"

where git >nul 2>&1
if errorlevel 1 (
    echo Error: git is required but was not found in PATH.
    exit /b 1
)

where go >nul 2>&1
if errorlevel 1 (
    echo Error: go is required but was not found in PATH.
    exit /b 1
)

where powershell.exe >nul 2>&1
if errorlevel 1 (
    echo Error: PowerShell is required to update the user PATH.
    exit /b 1
)

if not exist "%INSTALL_ROOT%" mkdir "%INSTALL_ROOT%"
if errorlevel 1 exit /b 1

if not exist "%BIN_DIR%" mkdir "%BIN_DIR%"
if errorlevel 1 exit /b 1

if exist "%SOURCE_DIR%\.git" (
    echo Updating RTM source...
    git -C "%SOURCE_DIR%" fetch --depth 1 origin main
    if errorlevel 1 exit /b 1

    git -C "%SOURCE_DIR%" checkout -B main origin/main
    if errorlevel 1 exit /b 1
) else (
    if exist "%SOURCE_DIR%" (
        echo Error: "%SOURCE_DIR%" exists but is not an RTM git checkout.
        exit /b 1
    )

    echo Cloning RTM...
    git clone --depth 1 --branch main "%REPO_URL%" "%SOURCE_DIR%"
    if errorlevel 1 exit /b 1
)

echo Building RTM...
pushd "%SOURCE_DIR%"
go build -o "%BIN_DIR%\rtm.exe" .
if errorlevel 1 (
    popd
    exit /b 1
)
popd

set "RTM_PATH_VALUE=%BIN_DIR%"
powershell.exe -NoProfile -ExecutionPolicy Bypass -Command "$bin=$env:RTM_PATH_VALUE; $path=[Environment]::GetEnvironmentVariable('Path','User'); if ([string]::IsNullOrWhiteSpace($path)) { $newPath=$bin } elseif (($path -split ';') -contains $bin) { exit 0 } else { $newPath=$path.TrimEnd(';')+';'+$bin }; [Environment]::SetEnvironmentVariable('Path',$newPath,'User')"
if errorlevel 1 (
    echo Warning: RTM was installed, but the user PATH could not be updated automatically.
    echo Add this directory to PATH manually: "%BIN_DIR%"
    exit /b 1
)

echo RTM installed: %BIN_DIR%\rtm.exe
echo Open a new terminal before using rtm.

endlocal
exit /b 0
