<#
.SYNOPSIS
    Starts the OPS Program Approval demo application locally.

.DESCRIPTION
    This script starts the backend (Spring Boot) and/or frontend (React) services
    for local development. It performs prerequisite checks, handles build steps,
    and launches each service in its own terminal window.

    The script supports running with local H2 database (default) or Azure SQL
    for testing cloud connectivity.

.PARAMETER SkipBuild
    Skip the build steps (mvnw package for backend, npm install for frontend).
    Use when code has already been built.

.PARAMETER BackendOnly
    Start only the backend service (port 8080). Cannot be used with -FrontendOnly.

.PARAMETER FrontendOnly
    Start only the frontend service (port 3000). Cannot be used with -BackendOnly.

.PARAMETER UseAzureSql
    Connect to Azure SQL instead of local H2 database. Requires AZURE_SQL_URL,
    AZURE_SQL_USERNAME, and AZURE_SQL_PASSWORD environment variables to be set.

.EXAMPLE
    .\Start-Local.ps1
    Builds and starts both backend and frontend services with local H2 database.

.EXAMPLE
    .\Start-Local.ps1 -SkipBuild
    Starts both services without rebuilding.

.EXAMPLE
    .\Start-Local.ps1 -BackendOnly -UseAzureSql
    Starts only the backend service connected to Azure SQL.

.EXAMPLE
    .\Start-Local.ps1 -FrontendOnly
    Starts only the frontend React development server.
#>

param(
    [switch]$SkipBuild,
    [switch]$BackendOnly,
    [switch]$FrontendOnly,
    [switch]$UseAzureSql
)

# Script configuration
$ErrorActionPreference = 'Stop'
$BackendPort = 8080
$FrontendPort = 3000
$RootPath = Split-Path -Parent $PSScriptRoot
$BackendPath = Join-Path $RootPath 'backend'
$FrontendPath = Join-Path $RootPath 'frontend'

# -----------------------------------------------------------------------------
# Prerequisite Checks
# -----------------------------------------------------------------------------

function Test-Prerequisites {
    param(
        [bool]$CheckJava,
        [bool]$CheckNode
    )

    $errors = @()

    if ($CheckJava) {
        $javaCmd = Get-Command java -ErrorAction SilentlyContinue
        if (-not $javaCmd) {
            $errors += "Java is not installed or not in PATH. Please install JDK 21+."
        } else {
            Write-Host "[Prerequisites] Java found: $($javaCmd.Source)" -ForegroundColor Green
        }
    }

    if ($CheckNode) {
        $nodeCmd = Get-Command node -ErrorAction SilentlyContinue
        $npmCmd = Get-Command npm -ErrorAction SilentlyContinue
        if (-not $nodeCmd) {
            $errors += "Node.js is not installed or not in PATH. Please install Node.js 20+."
        } else {
            Write-Host "[Prerequisites] Node found: $($nodeCmd.Source)" -ForegroundColor Green
        }
        if (-not $npmCmd) {
            $errors += "npm is not installed or not in PATH. Please install Node.js 20+."
        } else {
            Write-Host "[Prerequisites] npm found: $($npmCmd.Source)" -ForegroundColor Green
        }
    }

    if ($errors.Count -gt 0) {
        foreach ($error in $errors) {
            Write-Host "[Prerequisites] ERROR: $error" -ForegroundColor Red
        }
        exit 1
    }
}

# -----------------------------------------------------------------------------
# Parameter Validation
# -----------------------------------------------------------------------------

# Mutual exclusion check
if ($BackendOnly -and $FrontendOnly) {
    Write-Host "[Error] Cannot specify both -BackendOnly and -FrontendOnly. Choose one or neither." -ForegroundColor Red
    exit 1
}

# Azure SQL validation
if ($UseAzureSql) {
    $missingVars = @()
    if (-not $env:AZURE_SQL_URL) { $missingVars += 'AZURE_SQL_URL' }
    if (-not $env:AZURE_SQL_USERNAME) { $missingVars += 'AZURE_SQL_USERNAME' }
    if (-not $env:AZURE_SQL_PASSWORD) { $missingVars += 'AZURE_SQL_PASSWORD' }

    if ($missingVars.Count -gt 0) {
        Write-Host "[Error] -UseAzureSql requires the following environment variables:" -ForegroundColor Red
        foreach ($var in $missingVars) {
            Write-Host "  - $var" -ForegroundColor Red
        }
        exit 1
    }
    Write-Host "[Config] Using Azure SQL connection" -ForegroundColor Cyan
}

# -----------------------------------------------------------------------------
# Determine which services to run
# -----------------------------------------------------------------------------

$runBackend = -not $FrontendOnly
$runFrontend = -not $BackendOnly

# Check prerequisites based on what we're running
Test-Prerequisites -CheckJava $runBackend -CheckNode $runFrontend

# -----------------------------------------------------------------------------
# Build Phase
# -----------------------------------------------------------------------------

if (-not $SkipBuild) {
    Write-Host ""
    Write-Host "========================================" -ForegroundColor Cyan
    Write-Host "  Building Services" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan

    if ($runBackend) {
        Write-Host ""
        Write-Host "[Backend] Building with Maven..." -ForegroundColor Yellow
        Push-Location $BackendPath
        try {
            & .\mvnw.cmd package -DskipTests
            if ($LASTEXITCODE -ne 0) {
                Write-Host "[Backend] Build failed with exit code $LASTEXITCODE" -ForegroundColor Red
                exit $LASTEXITCODE
            }
            Write-Host "[Backend] Build completed successfully" -ForegroundColor Green
        }
        finally {
            Pop-Location
        }
    }

    if ($runFrontend) {
        Write-Host ""
        Write-Host "[Frontend] Installing dependencies with npm..." -ForegroundColor Yellow
        Push-Location $FrontendPath
        try {
            & npm install
            if ($LASTEXITCODE -ne 0) {
                Write-Host "[Frontend] npm install failed with exit code $LASTEXITCODE" -ForegroundColor Red
                exit $LASTEXITCODE
            }
            Write-Host "[Frontend] Dependencies installed successfully" -ForegroundColor Green
        }
        finally {
            Pop-Location
        }
    }
} else {
    Write-Host "[Build] Skipping build phase (-SkipBuild specified)" -ForegroundColor DarkGray
}

# -----------------------------------------------------------------------------
# Set Spring Profile
# -----------------------------------------------------------------------------

$springProfile = if ($UseAzureSql) { 'azure' } else { 'local' }
$env:SPRING_PROFILES_ACTIVE = $springProfile
Write-Host "[Config] SPRING_PROFILES_ACTIVE=$springProfile" -ForegroundColor Cyan

# -----------------------------------------------------------------------------
# Start Services
# -----------------------------------------------------------------------------

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "  Starting Services" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($runBackend) {
    Write-Host ""
    Write-Host "[Backend] Starting Spring Boot on port $BackendPort..." -ForegroundColor Yellow

    $backendArgs = @{
        FilePath         = 'cmd.exe'
        ArgumentList     = "/k cd /d `"$BackendPath`" && set SPRING_PROFILES_ACTIVE=$springProfile && .\mvnw.cmd spring-boot:run"
        WorkingDirectory = $BackendPath
    }
    Start-Process @backendArgs
    Write-Host "[Backend] Started in new terminal window" -ForegroundColor Green
}

if ($runFrontend) {
    Write-Host ""
    Write-Host "[Frontend] Starting React dev server on port $FrontendPort..." -ForegroundColor Yellow

    $frontendArgs = @{
        FilePath         = 'cmd.exe'
        ArgumentList     = "/k cd /d `"$FrontendPath`" && npm run dev"
        WorkingDirectory = $FrontendPath
    }
    Start-Process @frontendArgs
    Write-Host "[Frontend] Started in new terminal window" -ForegroundColor Green
}

# -----------------------------------------------------------------------------
# Summary Output
# -----------------------------------------------------------------------------

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "  Services Started Successfully" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
Write-Host ""

if ($runBackend) {
    Write-Host "  Backend API:  http://localhost:$BackendPort" -ForegroundColor White
    Write-Host "  Swagger UI:   http://localhost:$BackendPort/swagger-ui.html" -ForegroundColor White
    Write-Host "  H2 Console:   http://localhost:$BackendPort/h2-console" -ForegroundColor White
}

if ($runFrontend) {
    Write-Host "  Frontend:     http://localhost:$FrontendPort" -ForegroundColor White
}

Write-Host ""
Write-Host "Use scripts\Stop-Local.ps1 to stop all services." -ForegroundColor DarkGray
Write-Host ""
