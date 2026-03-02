# Operational Layer Research — OPS Program Approval Demo Scaffolding

**Subagent**: Researcher — Operational Layer\
**Date**: 2026-03-02\
**Status**: Complete\
**Scope**: `TALK-TRACK.md`, `scripts/Start-Local.ps1`, `scripts/Stop-Local.ps1`, ADO Work Item Creation Plan

---

## Table of Contents

1. [TALK-TRACK.md Research](#1-talk-trackmd-research)
2. [scripts/Start-Local.ps1 Research](#2-scriptsstart-localps1-research)
3. [scripts/Stop-Local.ps1 Research](#3-scriptsstop-localps1-research)
4. [ADO Work Item Creation Plan Research](#4-ado-work-item-creation-plan-research)
5. [Key Discoveries](#5-key-discoveries)
6. [Recommended Next Research](#6-recommended-next-research)
7. [Clarifying Questions](#7-clarifying-questions)

---

## 1. TALK-TRACK.md Research

### 1.1 Content Specification

The talk track is a 130-minute, minute-by-minute demo script placed at the **repository root** (not in `docs/`). It is the primary operational document the presenter follows during the live Developer Day 2026 demo.

#### Structure Overview

```text
TALK-TRACK.md
├── YAML Frontmatter (title, description)
├── Overview / Setup Checklist
├── Part 1: "Building From Zero" (Minutes 0–70)
│   ├── Opening (0–8)
│   ├── Act 1: The Architect (8–20)
│   ├── Act 2: The DBA (20–32)
│   ├── Act 3: The Backend Developer (32–52)
│   └── Act 4: The Frontend Developer (52–70)
├── Cliffhanger (Minute 70)
├── Part 2: "Closing the Loop" (Minutes 70–130)
│   ├── Recap (70–73)
│   ├── Act 5: Completing the Story (73–87)
│   ├── Act 6: The QA Engineer (87–100)
│   ├── Act 7: The DevOps Engineer (100–107)
│   ├── Act 8: The Full Stack Change (107–120)
│   └── Closing (120–130)
├── Commit Checkpoint Reference
├── Fast-Forward Recovery Strategy
├── Risk Mitigation Table
└── Key Numbers Summary Table
```

### 1.2 What Makes an Effective Demo Talk Track

An effective talk track for a live coding demo balances three concerns: **narrative flow**, **technical precision**, and **recovery resilience**.

**Narrative flow**: Each act should tell a mini-story. The presenter adopts a role (Architect, DBA, Backend Dev, etc.), states a problem, uses Copilot to solve it, and shows the result. The cliffhanger at minute 70 creates a compelling break — the citizen portal works but nobody can approve submissions.

**Technical precision**: Every demo action must be explicit enough that a presenter can execute it without improvisation. Commands should be copy-pasteable. File paths must be exact. Expected outputs should be described so the presenter can confirm things are working.

**Recovery resilience**: Every checkpoint has a tagged commit that the presenter can fast-forward to if something goes wrong. The talk track should never leave the presenter stranded.

#### Best Practices for Demo Talk Tracks

| Practice | Rationale |
|----------|-----------|
| Use blockquotes for scripted dialogue | Visually separates "what to say" from "what to do" |
| Use `Demo actions:` bullet lists with minute markers | Keeps the presenter on pace; easy to find current position |
| Include `Key beat:` callouts | Highlights the moment that delivers impact — do not skip |
| Include `Audience engagement point:` callouts | Marks natural pause points for questions or reactions |
| Show expected output after each action | Lets the presenter confirm success before moving on |
| Provide recovery commands inline | No need to flip to an appendix during a crisis |
| Keep each act self-contained | If an act runs long, the next act can start clean |

### 1.3 Timed Section Formatting

Each act section should follow this template:

```markdown
## Act N: Role Name (Minutes X–Y)

**Checkpoint**: `vN.N.0` | **Tag**: `git tag vN.N.0`

> "Scripted presenter dialogue goes in blockquotes. This is what you say
> out loud to the audience."

**Demo actions:**

- **[Minute X]** First action description
  ```bash
  # Command to run
  ```
  Expected output: description of what the audience sees

- **[Minute X+2]** Second action description

**Key beat:** The critical moment the audience should notice.

**Audience engagement point:** "Ask the audience: has anyone tried…"

> "Transition dialogue to next section."
```

**Why minute markers matter**: In a 130-minute demo, the presenter needs to know instantly whether they are ahead or behind schedule. Minute markers at the left margin are scannable during a live performance. If a presenter is at minute 45 and should be at minute 40, they know to speed up. If they are at minute 35, they can add ad-lib commentary.

**Recommended granularity**: Major actions every 2–3 minutes. Not every single keystroke, but every meaningful step that produces a visible result.

### 1.4 Tagged Commit Checkpoints

Checkpoints serve two purposes: (1) mark progress milestones for the audience, and (2) provide fast-forward recovery points if something breaks.

#### Recommended Checkpoint Scheme

| Tag | Checkpoint Name | What It Contains | Demo Minute |
|-----|----------------|------------------|-------------|
| `v0.1.0` | Scaffolding Complete | All 13 scaffolding files (config, docs, scripts, talk track). ADO work items created. | ~20 |
| `v0.2.0` | Database Ready | 4 Flyway migrations created and applied to H2 | ~32 |
| `v0.3.0` | API Running | Spring Boot project with 5 endpoints, passing curl tests | ~52 |
| `v0.4.0` | Citizen Portal Live | React app with Ontario DS, bilingual citizen portal, live form submission | ~70 |
| `v0.5.0` | Ministry Portal Complete | Review dashboard, detail page, approve/reject functional | ~87 |
| `v0.6.0` | Tests Passing | Backend controller tests, frontend component tests, accessibility tests | ~100 |
| `v0.7.0` | CI/CD Ready | GitHub Actions CI workflow, Dependabot, secret scanning configured | ~107 |
| `v0.8.0` | Budget Field Added | `program_budget` end-to-end: migration → entity → DTO → API → form → tests | ~120 |
| `v1.0.0` | Demo Complete | Final state — all features, tests, and CI complete | ~130 |

**Total checkpoints**: 9 (v0.1.0 through v0.8.0   + v1.0.0)

**Why this number**: One checkpoint per act or logical boundary. More than 12 checkpoints creates tagging overhead during the live demo. Fewer than 6 leaves too-large gaps for recovery.

#### Checkpoint Creation Pattern

Each checkpoint in the talk track should include:

```markdown
### Checkpoint: vN.N.0 — Checkpoint Name

**Create checkpoint:**

```bash
git add -A
git commit -m "checkpoint: description of state AB#XXX"
git tag vN.N.0
git push origin main --tags
```

**Recovery (fast-forward to this point):**

```bash
git checkout vN.N.0
# Continue demo from this point
```
```

### 1.5 Fast-Forward Recovery Strategy

The fast-forward strategy ensures the presenter can skip ahead if time runs short or if a Copilot generation fails repeatedly.

#### How It Works

1. **Before the live demo**: Pre-run the entire demo and push all checkpoint tags to the repository.
2. **During the demo**: If something breaks, the presenter announces "Let me fast-forward to where this would have landed" and checks out the next tag.
3. **After recovery**: Continue the demo from the checkpoint as if it had been built live.

#### Recovery Decision Matrix

| Situation | Time Lost | Action |
|-----------|-----------|--------|
| Copilot generates wrong code | < 2 min | Fix manually, continue |
| Copilot generates wrong code | 2–5 min | Retry once, then fast-forward |
| Build/compile error | < 1 min | Fix error, continue |
| Build/compile error | > 2 min | Fast-forward to checkpoint |
| Azure connectivity lost | Any | Switch to H2 local, continue |
| NPM/Maven download stall | > 1 min | Fast-forward (dependencies are in checkpoint) |
| Total time overrun > 10 min | — | Skip Act 6 (QA) or Act 7 (DevOps), fast-forward |

#### Pre-Demo Preparation Checklist

```markdown
- [ ] All checkpoint tags pushed to remote
- [ ] Each tag tested: clone, build, run, verify
- [ ] `scripts/Start-Local.ps1` verified at each checkpoint
- [ ] Azure SQL connectivity tested from demo machine
- [ ] ADO board accessible and empty
- [ ] Copilot extensions loaded and responding
- [ ] MCP server responding to test query
- [ ] Network connectivity stable (wired preferred)
- [ ] Backup hotspot available
```

### 1.6 Risk Mitigation Table Format

The risk mitigation table belongs near the end of the talk track for reference. Format:

```markdown
## Risk Mitigation

| Risk | Probability | Impact | Mitigation | Recovery |
|------|-------------|--------|------------|----------|
| Copilot generates incorrect code | High | Medium | Have expected code in checkpoint tags | Fast-forward to next tag |
| Copilot is slow or unresponsive | Medium | High | Pre-type some prompts; have clipboard snippets | Switch to pre-built checkpoint |
| Azure SQL connection fails | Low | High | Demo uses H2 local profile by default | Already on H2; skip Azure SQL demo |
| Azure portal is slow/down | Low | Medium | Have screenshots of resource group | Show screenshots, narrate |
| npm install / Maven build hangs | Medium | Medium | Pre-cache in local repo; use `--offline` if possible | Fast-forward to next checkpoint |
| ADO MCP fails to create work items | Low | High | Have ADO web portal open as backup | Create items manually in ADO UI |
| Demo machine crashes | Very Low | Critical | Second laptop with repo cloned | Switch laptops |
| Time overrun (Part 1 > 70 min) | Medium | Medium | Built-in buffer in Acts 3–4 | Compress curl tests; skip one API demo |
| Time overrun (Part 2 > 60 min) | Medium | Medium | Acts 6–7 are compressible | Skip bilingual verification or Dependabot |
| Network connectivity lost | Low | High | Local H2, local npm cache, offline Copilot? | No — Copilot requires network. Fast-forward. |
```

### 1.7 Key Numbers Summary Table

The final section of the talk track should summarize what was built. This gives the audience a concrete takeaway.

#### Recommended Metrics

```markdown
## Key Numbers

| Metric | Count |
|--------|-------|
| Total demo duration | 130 minutes |
| Lines of Java code | ~500 |
| Lines of TypeScript/React code | ~800 |
| Lines of SQL | ~100 |
| API endpoints | 5 |
| Database tables | 3 |
| Flyway migrations | 4 (+1 for budget field) |
| React pages/components | ~10 |
| Unit/integration tests | ~15–20 |
| ADO work items created | ~30 |
| ADO work items completed | ~30 |
| Git commits | ~20 |
| Tagged checkpoints | 9 |
| Languages supported | 2 (EN/FR) |
| WCAG 2.2 Level AA compliant | Yes |
| CI workflows | 1 |
| Security tools configured | 3 (Dependabot, Secret Scanning, GHAS) |
| Azure services used | 6+ (App Service ×2, SQL, Durable Functions, Logic Apps, AI Foundry) |
| Copilot interactions | ~50+ |
| Time to first working endpoint | ~45 minutes |
| Time to full-stack submission | ~70 minutes |
```

**Why these metrics**: They answer the executive question "what did Copilot actually build in 130 minutes?" The numbers are impressive enough to demonstrate value without being inflated. Actual counts will vary — these are estimates based on the demo structure and should be updated after the dry run.

### 1.8 Potential Pitfalls for the Talk Track

| Pitfall | Mitigation |
|---------|------------|
| Talk track is too long — presenter reads instead of demonstrating | Keep dialogue to 2–3 sentences per blockquote. The demo actions are the star. |
| Minute markers drift from reality | Build in 2–3 minutes of buffer per act. Compress or skip optional sub-steps. |
| Cliffhanger falls flat | Rehearse the transition. The ADO board showing "Not Started" Ministry stories is the visual punch. |
| Recovery tags are stale (code changed since tagging) | Re-tag all checkpoints after every significant change to the demo script. |
| Talk track file gets too large to scan on stage | Use Ctrl+F / browser find. Consider a companion one-page cheat sheet with just minute markers and act names. |

---

## 2. scripts/Start-Local.ps1 Research

### 2.1 Content Specification

A PowerShell script that starts the local development environment for the demo. It must handle four switch parameters and launch both backend and frontend processes, either individually or together.

### 2.2 PowerShell param() Block Syntax

The standard PowerShell `param()` block with switch parameters and comment-based help:

```powershell
<#
.SYNOPSIS
    Starts the local development environment for the OPS Program Approval demo.

.DESCRIPTION
    Launches the Spring Boot backend (port 8080) and/or the Vite frontend dev server
    (port 3000). By default both services start. The backend uses an H2 in-memory
    database with MODE=MSSQLServer for Azure SQL compatibility.

.PARAMETER SkipBuild
    Skip the Maven build (backend) and npm install (frontend) steps.
    Use when dependencies are already installed and code has not changed.

.PARAMETER BackendOnly
    Start only the Spring Boot backend on port 8080. Do not start the frontend.

.PARAMETER FrontendOnly
    Start only the Vite dev server on port 3000. Do not start the backend.

.PARAMETER UseAzureSql
    Connect the backend to Azure SQL instead of the default H2 in-memory database.
    Activates the 'azure' Spring profile instead of the 'local' profile.
    Requires AZURE_SQL_URL, AZURE_SQL_USERNAME, and AZURE_SQL_PASSWORD environment
    variables to be set.

.EXAMPLE
    .\scripts\Start-Local.ps1
    # Starts both backend and frontend with H2 database.

.EXAMPLE
    .\scripts\Start-Local.ps1 -BackendOnly -UseAzureSql
    # Starts only the backend connected to Azure SQL.

.EXAMPLE
    .\scripts\Start-Local.ps1 -SkipBuild -FrontendOnly
    # Starts only the frontend without running npm install.
#>
param(
    [switch]$SkipBuild,
    [switch]$BackendOnly,
    [switch]$FrontendOnly,
    [switch]$UseAzureSql
)
```

**Key details**:

- Switch parameters are `[switch]` type — they default to `$false` and become `$true` when specified.
- Comment-based help (`.SYNOPSIS`, `.DESCRIPTION`, `.PARAMETER`, `.EXAMPLE`) is the standard PowerShell documentation pattern. It enables `Get-Help .\scripts\Start-Local.ps1`.
- Parameters should be `PascalCase` following PowerShell conventions.

### 2.3 Starting Spring Boot from PowerShell

Spring Boot is started via Maven Wrapper:

```powershell
# Navigate to backend directory
Push-Location "$PSScriptRoot\..\backend"

# Build if not skipped
if (-not $SkipBuild) {
    Write-Host "Building backend..." -ForegroundColor Cyan
    & .\mvnw.cmd clean package -DskipTests
    if ($LASTEXITCODE -ne 0) {
        Write-Error "Maven build failed."
        Pop-Location
        exit 1
    }
}

# Determine Spring profile
$springProfile = if ($UseAzureSql) { "azure" } else { "local" }

# Start Spring Boot
Write-Host "Starting Spring Boot with profile '$springProfile' on port 8080..." -ForegroundColor Green
$env:SPRING_PROFILES_ACTIVE = $springProfile
& .\mvnw.cmd spring-boot:run
```

**Important considerations**:

- Use `mvnw.cmd` (Maven Wrapper) on Windows, not `./mvnw` (which is the Unix shell script).
- The `local` profile activates H2 with `MODE=MSSQLServer` via `application-local.yml`.
- The `azure` profile reads Azure SQL connection strings from environment variables.
- `$LASTEXITCODE` is PowerShell's equivalent of `$?` / exit code from native commands.

### 2.4 Starting Vite Dev Server from PowerShell

```powershell
# Navigate to frontend directory
Push-Location "$PSScriptRoot\..\frontend"

# Install dependencies if not skipped
if (-not $SkipBuild) {
    Write-Host "Installing frontend dependencies..." -ForegroundColor Cyan
    & npm install
    if ($LASTEXITCODE -ne 0) {
        Write-Error "npm install failed."
        Pop-Location
        exit 1
    }
}

# Start Vite dev server (port 3000 is configured in vite.config.ts)
Write-Host "Starting Vite dev server on port 3000..." -ForegroundColor Green
& npm run dev
```

**Note on port configuration**: Vite defaults to port 5173. The port is overridden to 3000 in `vite.config.ts` via `server.port: 3000`. The PowerShell script does not need to set the port — it relies on the Vite config.

### 2.5 Handling -UseAzureSql

When `-UseAzureSql` is specified, the script should:

1. Validate that required environment variables are set:

```powershell
if ($UseAzureSql) {
    $requiredVars = @('AZURE_SQL_URL', 'AZURE_SQL_USERNAME', 'AZURE_SQL_PASSWORD')
    $missing = $requiredVars | Where-Object { -not (Test-Path "Env:\$_") }
    if ($missing) {
        Write-Error "Missing environment variables for Azure SQL: $($missing -join ', ')"
        Write-Error "Set these variables before using -UseAzureSql."
        exit 1
    }
}
```

2. Set `SPRING_PROFILES_ACTIVE=azure` instead of `local`.

The `application-azure.yml` (or `application-azure.properties`) in the Spring Boot project would reference these environment variables:

```yaml
spring:
  datasource:
    url: ${AZURE_SQL_URL}
    username: ${AZURE_SQL_USERNAME}
    password: ${AZURE_SQL_PASSWORD}
    driver-class-name: com.microsoft.sqlserver.jdbc.SQLServerDriver
```

### 2.6 Prerequisite Checks

The script should verify that required tools are installed before attempting to use them:

```powershell
# Check prerequisites
$prerequisites = @{
    'java' = 'Java 21 is required. Install from https://adoptium.net/'
    'node' = 'Node.js 20+ is required. Install from https://nodejs.org/'
    'npm'  = 'npm is required (comes with Node.js).'
}

foreach ($tool in $prerequisites.Keys) {
    if (-not (Get-Command $tool -ErrorAction SilentlyContinue)) {
        Write-Error "$tool not found. $($prerequisites[$tool])"
        exit 1
    }
}
```

**Should we check versions?** Checking major versions (Java 21, Node 20) adds robustness but also complexity. For a demo script, checking existence is sufficient. The comment-based help should document version requirements.

### 2.7 Running Backend and Frontend in Parallel

This is the most technically interesting aspect. PowerShell has several approaches:

#### Option A: Background Jobs (Recommended for Demo)

```powershell
$backendJob = $null
$frontendJob = $null

try {
    if (-not $FrontendOnly) {
        $springProfile = if ($UseAzureSql) { "azure" } else { "local" }
        $backendDir = Resolve-Path "$PSScriptRoot\..\backend"
        $backendJob = Start-Job -ScriptBlock {
            Set-Location $using:backendDir
            $env:SPRING_PROFILES_ACTIVE = $using:springProfile
            & .\mvnw.cmd spring-boot:run 2>&1
        }
        Write-Host "Backend starting in background (Job ID: $($backendJob.Id))..." -ForegroundColor Green
    }

    if (-not $BackendOnly) {
        $frontendDir = Resolve-Path "$PSScriptRoot\..\frontend"
        $frontendJob = Start-Job -ScriptBlock {
            Set-Location $using:frontendDir
            & npm run dev 2>&1
        }
        Write-Host "Frontend starting in background (Job ID: $($frontendJob.Id))..." -ForegroundColor Green
    }

    Write-Host ""
    Write-Host "Services starting..." -ForegroundColor Yellow
    Write-Host "  Backend:  http://localhost:8080 (Spring Boot)" -ForegroundColor White
    Write-Host "  Frontend: http://localhost:3000 (Vite)" -ForegroundColor White
    Write-Host ""
    Write-Host "Press Ctrl+C to stop all services." -ForegroundColor Yellow

    # Wait for jobs, streaming output
    while ($true) {
        if ($backendJob) { Receive-Job $backendJob }
        if ($frontendJob) { Receive-Job $frontendJob }
        Start-Sleep -Milliseconds 500
    }
}
finally {
    # Cleanup on Ctrl+C
    if ($backendJob) {
        Stop-Job $backendJob -ErrorAction SilentlyContinue
        Remove-Job $backendJob -ErrorAction SilentlyContinue
    }
    if ($frontendJob) {
        Stop-Job $frontendJob -ErrorAction SilentlyContinue
        Remove-Job $frontendJob -ErrorAction SilentlyContinue
    }
}
```

#### Option B: Start-Process (Simpler, Separate Windows)

```powershell
if (-not $FrontendOnly) {
    $springProfile = if ($UseAzureSql) { "azure" } else { "local" }
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c cd /d backend && set SPRING_PROFILES_ACTIVE=$springProfile && mvnw.cmd spring-boot:run" -WorkingDirectory "$PSScriptRoot\.."
}

if (-not $BackendOnly) {
    Start-Process -FilePath "cmd.exe" -ArgumentList "/c cd /d frontend && npm run dev" -WorkingDirectory "$PSScriptRoot\.."
}
```

**Trade-offs**:

| Approach | Pros | Cons |
|----------|------|------|
| Background Jobs | Single terminal, Ctrl+C cleanup, output interleaved | More complex code, `$using:` scope rules |
| Start-Process | Simple, each service in its own window | Two extra windows, no unified Ctrl+C |

**Recommendation**: Use **Start-Process** for the demo script. It is simpler, visually clear (each service in its own window), and avoids the complexity of job management. The `Stop-Local.ps1` script handles cleanup. For a demo, simplicity wins over elegance.

### 2.8 Process Cleanup on Interruption

If using background jobs, the `finally` block handles Ctrl+C cleanup. If using `Start-Process`, the companion `Stop-Local.ps1` script is the cleanup mechanism.

PowerShell `try/finally` with `[Console]::TreatControlCAsInput` can trap Ctrl+C, but this is fragile and not recommended for a demo script. Instead, rely on `Stop-Local.ps1`.

### 2.9 Complete Recommended Script

```powershell
<#
.SYNOPSIS
    Starts the local development environment for the OPS Program Approval demo.

.DESCRIPTION
    Launches the Spring Boot backend (port 8080) and/or the Vite frontend dev
    server (port 3000). By default both services start in separate terminal
    windows. The backend uses an H2 in-memory database with MODE=MSSQLServer
    for Azure SQL compatibility.

.PARAMETER SkipBuild
    Skip Maven package (backend) and npm install (frontend).

.PARAMETER BackendOnly
    Start only the Spring Boot backend on port 8080.

.PARAMETER FrontendOnly
    Start only the Vite dev server on port 3000.

.PARAMETER UseAzureSql
    Use the 'azure' Spring profile instead of 'local' (H2).
    Requires AZURE_SQL_URL, AZURE_SQL_USERNAME, AZURE_SQL_PASSWORD
    environment variables.

.EXAMPLE
    .\scripts\Start-Local.ps1

.EXAMPLE
    .\scripts\Start-Local.ps1 -BackendOnly -UseAzureSql

.EXAMPLE
    .\scripts\Start-Local.ps1 -SkipBuild -FrontendOnly
#>
param(
    [switch]$SkipBuild,
    [switch]$BackendOnly,
    [switch]$FrontendOnly,
    [switch]$UseAzureSql
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

# --- Validation -----------------------------------------------------------

if ($BackendOnly -and $FrontendOnly) {
    Write-Error "Cannot specify both -BackendOnly and -FrontendOnly."
    exit 1
}

# Check prerequisites
if (-not $FrontendOnly) {
    if (-not (Get-Command java -ErrorAction SilentlyContinue)) {
        Write-Error "Java not found. Install Java 21 from https://adoptium.net/"
        exit 1
    }
}

if (-not $BackendOnly) {
    if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
        Write-Error "Node.js not found. Install Node.js 20+ from https://nodejs.org/"
        exit 1
    }
}

if ($UseAzureSql) {
    $requiredVars = @('AZURE_SQL_URL', 'AZURE_SQL_USERNAME', 'AZURE_SQL_PASSWORD')
    $missing = $requiredVars | Where-Object { -not (Test-Path "Env:\$_") }
    if ($missing.Count -gt 0) {
        Write-Error "Missing environment variables for Azure SQL: $($missing -join ', ')"
        exit 1
    }
}

$repoRoot = Resolve-Path "$PSScriptRoot\.."

# --- Backend ---------------------------------------------------------------

if (-not $FrontendOnly) {
    $backendDir = Join-Path $repoRoot 'backend'

    if (-not (Test-Path $backendDir)) {
        Write-Error "Backend directory not found: $backendDir"
        exit 1
    }

    if (-not $SkipBuild) {
        Write-Host "[Backend] Building with Maven..." -ForegroundColor Cyan
        Push-Location $backendDir
        & .\mvnw.cmd clean package -DskipTests
        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            Write-Error "Maven build failed."
            exit 1
        }
        Pop-Location
    }

    $springProfile = if ($UseAzureSql) { 'azure' } else { 'local' }
    Write-Host "[Backend] Starting Spring Boot (profile: $springProfile, port: 8080)..." -ForegroundColor Green
    Start-Process pwsh -ArgumentList "-NoExit", "-Command", "Set-Location '$backendDir'; `$env:SPRING_PROFILES_ACTIVE='$springProfile'; .\mvnw.cmd spring-boot:run" -WorkingDirectory $backendDir
}

# --- Frontend --------------------------------------------------------------

if (-not $BackendOnly) {
    $frontendDir = Join-Path $repoRoot 'frontend'

    if (-not (Test-Path $frontendDir)) {
        Write-Error "Frontend directory not found: $frontendDir"
        exit 1
    }

    if (-not $SkipBuild) {
        Write-Host "[Frontend] Installing npm dependencies..." -ForegroundColor Cyan
        Push-Location $frontendDir
        & npm install
        if ($LASTEXITCODE -ne 0) {
            Pop-Location
            Write-Error "npm install failed."
            exit 1
        }
        Pop-Location
    }

    Write-Host "[Frontend] Starting Vite dev server (port: 3000)..." -ForegroundColor Green
    Start-Process pwsh -ArgumentList "-NoExit", "-Command", "Set-Location '$frontendDir'; npm run dev" -WorkingDirectory $frontendDir
}

# --- Summary ----------------------------------------------------------------

Write-Host ""
Write-Host "=== Local Environment ===" -ForegroundColor Yellow
if (-not $FrontendOnly) {
    Write-Host "  Backend:  http://localhost:8080" -ForegroundColor White
}
if (-not $BackendOnly) {
    Write-Host "  Frontend: http://localhost:3000" -ForegroundColor White
}
Write-Host ""
Write-Host "Run .\scripts\Stop-Local.ps1 to stop all services." -ForegroundColor Yellow
```

### 2.10 Potential Pitfalls

| Pitfall | Mitigation |
|---------|------------|
| `mvnw.cmd` not found (backend not yet scaffolded) | Script checks for `$backendDir` existence before attempting build |
| Port already in use | Run `Stop-Local.ps1` first; could add port check but adds complexity |
| `Start-Process pwsh` opens PowerShell 7 but user has only PowerShell 5 | Use `powershell` as fallback; detect with `$PSVersionTable.PSEdition` |
| `-UseAzureSql` env vars not set | Explicit validation with helpful error message |
| Maven downloads slow on first run | `-SkipBuild` available; pre-cache in dry run |

---

## 3. scripts/Stop-Local.ps1 Research

### 3.1 Content Specification

A PowerShell script that finds and kills any processes listening on ports 8080 (backend) and 3000 (frontend). It must handle the case where no process is running on either port.

### 3.2 Finding Processes by Port on Windows

Windows PowerShell provides `Get-NetTCPConnection` to find TCP connections by port:

```powershell
# Find process ID listening on port 8080
$connections = Get-NetTCPConnection -LocalPort 8080 -State Listen -ErrorAction SilentlyContinue
if ($connections) {
    $processId = $connections[0].OwningProcess
    $process = Get-Process -Id $processId -ErrorAction SilentlyContinue
    if ($process) {
        Write-Host "Stopping $($process.ProcessName) (PID: $processId) on port 8080..."
        Stop-Process -Id $processId -Force
    }
}
```

**Key details about `Get-NetTCPConnection`**:

- Available in PowerShell 5.1+ on Windows 10/Server 2016+.
- Filter by `-LocalPort` (the port number) and `-State Listen` (only listening sockets, not client connections).
- Returns `OwningProcess` property which is the PID.
- Use `-ErrorAction SilentlyContinue` because the cmdlet throws a terminating error if no connections match the filter.

### 3.3 Alternative: netstat-based Approach

For broader compatibility (e.g., PowerShell on Linux/macOS where `Get-NetTCPConnection` may not be available):

```powershell
# Cross-platform alternative using netstat
$netstatOutput = netstat -ano | Select-String ":8080\s" | Select-String "LISTENING"
if ($netstatOutput) {
    $pid = ($netstatOutput -split '\s+')[-1]
    Stop-Process -Id $pid -Force
}
```

**Recommendation**: Use `Get-NetTCPConnection` for the primary implementation since this is a Windows-targeted demo project. The README and all prompts specify PowerShell on Windows.

### 3.4 Graceful vs. Force Shutdown

| Approach | How | When to Use |
|----------|-----|-------------|
| Graceful | `Stop-Process -Id $pid` (no `-Force`) | Production scripts; gives process time to finish |
| Force | `Stop-Process -Id $pid -Force` | Demo scripts; immediate cleanup |

**Recommendation**: Use `-Force`. In a demo context, the presenter wants instant cleanup. Spring Boot's graceful shutdown is irrelevant for a local H2 database. Vite has no shutdown hooks.

### 3.5 Handling No Process Running

The script must not error when no process is found on a port:

```powershell
function Stop-ProcessOnPort {
    param(
        [Parameter(Mandatory)]
        [int]$Port,

        [string]$ServiceName = "Service"
    )

    $connections = Get-NetTCPConnection -LocalPort $Port -State Listen -ErrorAction SilentlyContinue
    if (-not $connections) {
        Write-Host "[$ServiceName] No process found on port $Port." -ForegroundColor DarkGray
        return
    }

    # May be multiple connections (e.g., IPv4 + IPv6); get unique PIDs
    $pids = $connections | Select-Object -ExpandProperty OwningProcess -Unique

    foreach ($pid in $pids) {
        $process = Get-Process -Id $pid -ErrorAction SilentlyContinue
        if ($process) {
            Write-Host "[$ServiceName] Stopping $($process.ProcessName) (PID: $pid) on port $Port..." -ForegroundColor Yellow
            Stop-Process -Id $pid -Force
            Write-Host "[$ServiceName] Stopped." -ForegroundColor Green
        }
    }
}
```

**Why handle multiple PIDs**: A port can have both IPv4 and IPv6 listeners, resulting in multiple `Get-NetTCPConnection` results. Using `Select-Object -Unique` avoids attempting to kill the same PID twice.

### 3.6 Complete Recommended Script

```powershell
<#
.SYNOPSIS
    Stops the local development environment for the OPS Program Approval demo.

.DESCRIPTION
    Finds and kills any processes listening on port 8080 (Spring Boot backend)
    and port 3000 (Vite frontend dev server). Safe to run even if no processes
    are running on those ports.

.EXAMPLE
    .\scripts\Stop-Local.ps1
#>

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

function Stop-ProcessOnPort {
    param(
        [Parameter(Mandatory)]
        [int]$Port,

        [string]$ServiceName = "Service"
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
            Write-Host "[$ServiceName] Stopping $($proc.ProcessName) (PID: $processId) on port $Port..." -ForegroundColor Yellow
            Stop-Process -Id $processId -Force
            Write-Host "[$ServiceName] Stopped." -ForegroundColor Green
        }
    }
}

Write-Host "Stopping local development services..." -ForegroundColor Cyan
Write-Host ""

Stop-ProcessOnPort -Port 8080 -ServiceName "Backend"
Stop-ProcessOnPort -Port 3000 -ServiceName "Frontend"

Write-Host ""
Write-Host "All services stopped." -ForegroundColor Green
```

### 3.7 Cross-Platform Considerations

**Should the script be cross-platform?** No. The project specifies PowerShell scripts and the demo runs on Windows. `Get-NetTCPConnection` is a Windows-only cmdlet. If future cross-platform support is needed, a `stop-local.sh` bash script would be the Linux/macOS counterpart, but that is out of scope.

### 3.8 Potential Pitfalls

| Pitfall | Mitigation |
|---------|------------|
| `Get-NetTCPConnection` requires elevation for some queries | `-State Listen` works without elevation on modern Windows |
| Killing parent process leaves orphan child processes | Java spawns child processes; `-Force` typically propagates. If not, killing by port is sufficient. |
| Port held by a non-demo process | The script kills whatever is on the port. Add a confirmation prompt if concerned, but for demo use this is unnecessary. |
| `Stop-Process` throws if PID already exited | `-ErrorAction SilentlyContinue` on `Get-Process` handles race condition |

---

## 4. ADO Work Item Creation Plan Research

### 4.1 Content Specification

During Act 1 (minutes 8–20), the presenter uses the Azure DevOps MCP server to create the complete work item hierarchy: 1 Epic, 8 Features, and ~24 Stories. No work items exist beforehand — the ADO board is empty at demo start.

### 4.2 How azure-devops-mcp Creates Work Items

The `azure-devops-mcp` package exposes MCP tools that Copilot can invoke. The key tool for work item creation maps to the Azure DevOps REST API:

```text
POST https://dev.azure.com/{organization}/{project}/_apis/wit/workitems/${type}?api-version=7.1
```

Each MCP `create_work_item` call typically accepts:

| Parameter | Description |
|-----------|-------------|
| `type` | Work item type: `Epic`, `Feature`, or `User Story` |
| `title` | Work item title |
| `description` | HTML or plain text description (optional but recommended) |
| `parentId` | ID of the parent work item to link to (for hierarchy) |
| `state` | Initial state: `New`, `Active`, `Closed` |
| `areaPath` | Area path (defaults to project root) |
| `iterationPath` | Iteration path (defaults to project root) |

**Linking mechanism**: The `parentId` parameter creates a parent-child link. The MCP tool handles this by adding a `System.LinkTypes.Hierarchy-Reverse` link in the PATCH document. This means:

1. Create the Epic first → get its ID
2. Create each Feature with `parentId` = Epic ID → get each Feature ID
3. Create each Story with `parentId` = its parent Feature ID

### 4.3 Recommended Creation Order

The hierarchy must be created **top-down** because child items reference parent IDs:

```text
Step 1: Create Epic "OPS Program Approval System" → returns ID 1
Step 2: Create Feature "Infrastructure Setup" (parent: 1) → returns ID 2
Step 3: Create Feature "Database Layer" (parent: 1) → returns ID 3
Step 4: Create Feature "Backend API" (parent: 1) → returns ID 4
Step 5: Create Feature "Citizen Portal" (parent: 1) → returns ID 5
Step 6: Create Feature "Ministry Portal" (parent: 1) → returns ID 6
Step 7: Create Feature "Quality Assurance" (parent: 1) → returns ID 7
Step 8: Create Feature "CI/CD Pipeline" (parent: 1) → returns ID 8
Step 9: Create Feature "Live Change Demo" (parent: 1) → returns ID 9
Step 10–13: Create 4 Database Layer stories (parent: 3)
Step 14–18: Create 5 Backend API stories (parent: 4)
Step 19–24: Create 6 Citizen Portal stories (parent: 5)
Step 25–27: Create 3 Ministry Portal stories (parent: 6)
Step 28–31: Create 4 Quality Assurance stories (parent: 7)
Step 32–34: Create 3 CI/CD Pipeline stories (parent: 8)
Step 35–36: Create 2 Live Change Demo stories (parent: 9)
```

**Total items**: 1 Epic + 8 Features + 27 Stories = **36 work items**

### 4.4 Complete Work Item Hierarchy

#### Epic

| # | Type | Title | Parent | Initial State |
|---|------|-------|--------|---------------|
| 1 | Epic | OPS Program Approval System | — | New |

#### Features

| # | Type | Title | Parent | Initial State | Notes |
|---|------|-------|--------|---------------|-------|
| 2 | Feature | Infrastructure Setup | Epic | New → **Closed** | Pre-deployed in `rg-dev-125`; close immediately |
| 3 | Feature | Database Layer | Epic | New | |
| 4 | Feature | Backend API | Epic | New | |
| 5 | Feature | Citizen Portal | Epic | New | |
| 6 | Feature | Ministry Portal | Epic | New | Unstarted at cliffhanger |
| 7 | Feature | Quality Assurance | Epic | New | |
| 8 | Feature | CI/CD Pipeline | Epic | New | |
| 9 | Feature | Live Change Demo | Epic | New | |

#### Stories — Database Layer (Feature #3)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 10 | User Story | Create program_type table | Database Layer |
| 11 | User Story | Create program table | Database Layer |
| 12 | User Story | Create notification table | Database Layer |
| 13 | User Story | Insert seed data | Database Layer |

#### Stories — Backend API (Feature #4)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 14 | User Story | Spring Boot project scaffolding | Backend API |
| 15 | User Story | Submit program endpoint (POST /api/programs) | Backend API |
| 16 | User Story | List and get program endpoints (GET /api/programs, GET /api/programs/{id}) | Backend API |
| 17 | User Story | Review program endpoint (PUT /api/programs/{id}/review) | Backend API |
| 18 | User Story | Program types endpoint (GET /api/program-types) | Backend API |

#### Stories — Citizen Portal (Feature #5)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 19 | User Story | React project scaffolding with Vite | Citizen Portal |
| 20 | User Story | Ontario DS layout (Header, Footer, LanguageToggle) | Citizen Portal |
| 21 | User Story | Program submission form | Citizen Portal |
| 22 | User Story | Submission confirmation page | Citizen Portal |
| 23 | User Story | Program search page | Citizen Portal |
| 24 | User Story | Bilingual EN/FR support with i18next | Citizen Portal |

#### Stories — Ministry Portal (Feature #6)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 25 | User Story | Review dashboard page | Ministry Portal |
| 26 | User Story | Review detail page | Ministry Portal |
| 27 | User Story | Approve/reject actions | Ministry Portal |

#### Stories — Quality Assurance (Feature #7)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 28 | User Story | Backend controller tests | Quality Assurance |
| 29 | User Story | Frontend component tests | Quality Assurance |
| 30 | User Story | Accessibility tests | Quality Assurance |
| 31 | User Story | Bilingual verification | Quality Assurance |

#### Stories — CI/CD Pipeline (Feature #8)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 32 | User Story | CI workflow (GitHub Actions) | CI/CD Pipeline |
| 33 | User Story | Dependabot config | CI/CD Pipeline |
| 34 | User Story | Secret scanning | CI/CD Pipeline |

#### Stories — Live Change Demo (Feature #9)

| # | Type | Title | Parent |
|---|------|-------|--------|
| 35 | User Story | Add program_budget field end-to-end | Live Change Demo |
| 36 | User Story | Update tests for new field | Live Change Demo |

### 4.5 Timing Analysis: Is 12 Minutes Realistic?

Act 1 runs from minute 8 to minute 20 (12 minutes). It includes:

1. Running scaffolding prompts (generates config/docs/script files)
2. Configuring MCP
3. Creating all 36 ADO work items via MCP

**Time estimate for work item creation**:

| Activity | Items | Time per Item | Total |
|----------|-------|---------------|-------|
| Copilot prompt to create Epic | 1 | 15–30 sec | ~0.5 min |
| Copilot prompt to create Features | 8 | 10–20 sec each | ~2 min |
| Copilot prompt to create Stories (batched by Feature) | 27 | 5–15 sec each | ~5 min |
| Review ADO board / handle MCP errors | — | — | ~1–2 min |
| **Subtotal for ADO work items** | **36** | — | **~8–10 min** |

**Assessment**: 12 minutes is **tight but feasible** if:

- MCP is pre-configured (`.vscode/mcp.json` already created in scaffolding step).
- The presenter batches story creation by Feature (e.g., "Create all 4 Database Layer stories").
- Copilot understands batch creation (which it typically does with MCP tools).
- No MCP authentication issues.

**Risk mitigation**: If MCP is slow or fails, the presenter can:

1. Create the Epic + Features (9 items) live (~3 min).
2. Fast-forward: switch to a pre-populated ADO board and say "Copilot would continue creating all 27 stories — let me jump ahead."
3. Show the populated board.

**Batching strategy**: Instead of creating stories one at a time, prompt Copilot with:

> "Create the following User Stories under the Database Layer feature: Create program_type table, Create program table, Create notification table, Insert seed data."

This allows Copilot to make multiple MCP calls in sequence from a single prompt, which is faster than individual prompts per story.

### 4.6 Work Item Content: Titles Only or Full Descriptions?

**Recommendation**: **Titles with brief descriptions**. Full acceptance criteria take too long to create during a 12-minute live segment. However, having at least a one-line description adds professionalism to the ADO board view.

Example:

```text
Title: Submit program endpoint (POST /api/programs)
Description: Implement the POST /api/programs endpoint that accepts a ProgramSubmitRequest DTO, validates required fields, and persists a new program with status DRAFT.
```

**Acceptance criteria** can be added as a stretch goal if time permits, but should not be part of the core demo flow. The audience will see the titles on the ADO board — that is the visual impact.

### 4.7 Initial Work Item States

| Type | Initial State | Rationale |
|------|---------------|-----------|
| Epic | New | Will transition to Active when first Feature starts |
| Feature: Infrastructure Setup | New → **Closed** immediately | Already deployed in `rg-dev-125` |
| All other Features | New | Transition to Active as work begins in each act |
| All Stories | New | Transition to Active → Closed during each act |

**State transitions during the demo**:

- When the presenter starts Act 2 (DBA), the Database Layer feature moves to Active.
- As each migration story is completed, the story moves to Closed.
- At the cliffhanger (minute 70), Ministry Portal stories remain in New — this is the visual drama.
- By minute 130, all stories should be Closed.

**How to transition states**: The presenter can use MCP to update work item states, or do it manually on the ADO board. For demo purposes, using the ADO board UI for state transitions is more visual and audience-friendly than MCP commands.

### 4.8 Potential Pitfalls for ADO Operations

| Pitfall | Mitigation |
|---------|------------|
| MCP server fails to start | Have ADO web portal open as backup; create items manually |
| MCP authentication token expires | Re-authenticate via `npx azure-devops-mcp` (has PAT or OAuth flow) |
| ADO rate limiting (429) | Batch creation reduces calls; add 500ms delay between batches |
| Parent ID not returned correctly | Verify Epic ID before creating Features; use ADO query to find if needed |
| Duplicate work items on retry | Check for existing items before creating; ADO allows duplicates so this is cosmetic |
| ADO board doesn't refresh in browser | Hard refresh the board page; or close and reopen |

### 4.9 MCP Configuration Reference

The MCP server is configured in `.vscode/mcp.json`:

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "azure-devops-mcp",
        "--organization",
        "MngEnvMCAP675646",
        "--project",
        "ProgramDemo-DevDay2026-DryRun2"
      ]
    }
  }
}
```

**Prerequisites**:

- Node.js 20+ installed (for `npx`).
- Azure DevOps PAT (Personal Access Token) with `Work Items: Read & Write` scope, configured as an environment variable or via the MCP login flow.
- Network connectivity to `dev.azure.com`.

**First-run behavior**: `npx -y azure-devops-mcp` downloads the package on first run. This may take 10–30 seconds. In a demo, pre-run this once before going live to cache the package.

---

## 5. Key Discoveries

1. **36 work items, not ~30**: The full hierarchy contains 1 Epic + 8 Features + 27 Stories = 36 items. The user request estimated ~30. This is important for timing.

2. **12-minute ADO window is feasible but tight**: Batching story creation by Feature and pre-configuring MCP makes it possible. A fast-forward recovery is essential in case MCP is slow.

3. **9 tagged checkpoints is optimal**: One per act boundary plus a final v1.0.0. This provides granular recovery without excessive tagging overhead.

4. **Start-Process is better than background jobs for the demo**: Each service gets its own window, making it visually clear to the audience what is running. `Stop-Local.ps1` handles cleanup.

5. **Get-NetTCPConnection is the right tool for port-based process killing**: Windows-native, available in PowerShell 5.1+, no external dependencies.

6. **Talk track should use minute markers at bullet level, not paragraph level**: The presenter scans for `[Minute XX]` to know where they are. Paragraphs are harder to scan during a live demo.

7. **Infrastructure Setup feature should be closed immediately after creation**: This demonstrates the "pre-deployed" concept and removes it from the visual backlog noise.

8. **The cliffhanger depends on Ministry Portal stories being visually "New" on the ADO board**: This is the dramatic moment. The board must be displayed at minute 70 with those 3 stories clearly unstarted.

9. **Recovery decision matrix should be in the talk track, not a separate doc**: The presenter needs it immediately accessible when things go wrong — not in a separate file.

10. **Key numbers table serves the executive audience**: Technical audience sees the code; executives need quantified impact. Include both building metrics (lines of code, endpoints) and process metrics (time to first endpoint, Copilot interactions).

---

## 6. Recommended Next Research

| Topic | Reason | Priority |
|-------|--------|----------|
| Azure DevOps MCP authentication flow | Need to verify PAT vs. OAuth vs. browser-based auth for the demo machine | High |
| MCP batch work item creation capabilities | Verify if MCP supports creating multiple items in one call vs. sequential | High |
| Actual Copilot prompt phrasing for ADO operations | What exact prompts produce reliable MCP work item creation? | Medium |
| Pre-demo preparation automation | Script to verify all prerequisites (tags, tools, connectivity, ADO empty) | Medium |
| Talk track companion cheat sheet | One-page printable summary with just act names, minute markers, and checkpoint tags | Low |
| Cross-platform script equivalents | Bash versions of Start-Local and Stop-Local for macOS/Linux | Low |

---

## 7. Clarifying Questions

1. **ADO PAT scope**: Should the research document specify the exact PAT permissions needed (e.g., `vso.work_write`) or is that handled by the MCP auth flow?

2. **Pre-populated fallback board**: Should there be a separate ADO project with pre-populated work items as a complete fallback, or is fast-forwarding to a checkpoint with a populated board sufficient?

3. **Talk track audience**: Is the talk track for a single presenter or co-presenters? The script is written for one presenter switching hats, but co-presentation would change the dialogue format.

4. **Key numbers accuracy**: Should the key numbers table contain exact values (requiring a full dry run count) or estimated ranges? The current research uses estimates with notes to update after dry run.

5. **State transitions during demo**: Should the presenter update work item states via MCP (more impressive) or via the ADO board UI (more visual)? The research recommends ADO board UI but the talk track could go either way.
