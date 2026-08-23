$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $MyInvocation.MyCommand.Path
$listener = Get-NetTCPConnection -LocalPort 8765 -State Listen -ErrorAction SilentlyContinue
if (-not $listener) {
    $python = Get-Command py.exe -ErrorAction SilentlyContinue
    if ($python) {
        Start-Process -FilePath $python.Source -ArgumentList @('-3.12', (Join-Path $root 'piggybank.py')) -WorkingDirectory $root -WindowStyle Hidden
    } else {
        $python = Get-Command python.exe -ErrorAction Stop
        Start-Process -FilePath $python.Source -ArgumentList @((Join-Path $root 'piggybank.py')) -WorkingDirectory $root -WindowStyle Hidden
    }
    Start-Sleep -Milliseconds 900
}
Start-Process 'http://127.0.0.1:8765/'
