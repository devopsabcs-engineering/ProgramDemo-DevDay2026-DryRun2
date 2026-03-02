<#
.SYNOPSIS
    Stops the OPS Program Approval demo application services.

.DESCRIPTION
    This script stops any processes listening on the backend (port 8080) and
    frontend (port 3000) ports. It gracefully handles cases where no processes
    are running on those ports.

    The script uses Get-NetTCPConnection to identify processes by port and
    Stop-Process with -Force for immediate cleanup.

.EXAMPLE
    .\Stop-Local.ps1
    Stops both backend and frontend services if they are running.
#>

# Script configuration
$ErrorActionPreference = 'Continue'

# -----------------------------------------------------------------------------
# Helper Function
# -----------------------------------------------------------------------------

function Stop-ProcessOnPort {
    param(
        [int]$Port,
        [string]$ServiceName
    )

    $connections = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue

    if (-not $connections) {
        Write-Host "[$ServiceName] No process found on port $Port." -ForegroundColor DarkGray
        return
    }

    $pids = $connections | Select-Object -ExpandProperty OwningProcess -Unique

    foreach ($processId in $pids) {
        $proc = Get-Process -Id $processId -ErrorAction SilentlyContinue
        if ($proc) {
            Write-Host "[$ServiceName] Stopping $($proc.ProcessName) (PID: $processId)..." -ForegroundColor Yellow
            Stop-Process -Id $processId -Force
            Write-Host "[$ServiceName] Stopped successfully." -ForegroundColor Green
        }
    }
}

# -----------------------------------------------------------------------------
# Main Execution
# -----------------------------------------------------------------------------

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Stopping Local Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

Stop-ProcessOnPort -Port 8080 -ServiceName "Backend"
Stop-ProcessOnPort -Port 3000 -ServiceName "Frontend"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Cleanup Complete" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""
