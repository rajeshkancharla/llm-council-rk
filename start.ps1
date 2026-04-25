# Windows PowerShell startup script for LLM Council

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Definition
$envPath = Join-Path $scriptDir ".env"

if (-not (Test-Path $envPath)) {
    Write-Host "ERROR: .env file not found in the project root." -ForegroundColor Red
    Write-Host "Create a file named .env with this line:"
    Write-Host "OPENROUTER_API_KEY=sk-or-v1-..."
    Exit 1
}

$envText = Get-Content $envPath | ForEach-Object { $_.Trim() } | Where-Object { $_ -and -not $_.StartsWith("#") }
if (-not ($envText -match "^OPENROUTER_API_KEY=")) {
    Write-Host "ERROR: OPENROUTER_API_KEY not found in .env." -ForegroundColor Red
    Write-Host "Add a line like: OPENROUTER_API_KEY=sk-or-v1-..."
    Exit 1
}

$pwshCommand = Get-Command pwsh -ErrorAction SilentlyContinue
if ($pwshCommand) {
    $pwshExe = $pwshCommand.Source
} else {
    $powershellCommand = Get-Command powershell.exe -ErrorAction SilentlyContinue
    if ($powershellCommand) {
        $pwshExe = $powershellCommand.Source
    }
}

if (-not $pwshExe) {
    Write-Host "ERROR: PowerShell executable not found." -ForegroundColor Red
    Write-Host "Please run this script from PowerShell." 
    Exit 1
}

Write-Host "Starting LLM Council..."
Write-Host "Backend: http://localhost:8001"
Write-Host "Frontend: http://localhost:5173"
Write-Host ""

$backendArgs = "-NoExit", "-Command", "Set-Location '$scriptDir'; uv run python -m backend.main"
$frontendArgs = "-NoExit", "-Command", "Set-Location '$scriptDir\frontend'; npm run dev"

$backendProcess = Start-Process -FilePath $pwshExe -ArgumentList $backendArgs -PassThru
Start-Sleep -Seconds 2
$frontendProcess = Start-Process -FilePath $pwshExe -ArgumentList $frontendArgs -PassThru

Write-Host "Started backend PID $($backendProcess.Id) and frontend PID $($frontendProcess.Id)."
Write-Host "Press Enter to stop both servers."
Read-Host | Out-Null

Write-Host "Stopping servers..."
Stop-Process -Id $backendProcess.Id -ErrorAction SilentlyContinue
Stop-Process -Id $frontendProcess.Id -ErrorAction SilentlyContinue
Write-Host "Stopped."
