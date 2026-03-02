---
description: "Creates a 4-phase implementation plan from the demo scaffolding research document — configuration, documentation, scripts, and talk track"
agent: Task Planner
argument-hint: "[chat={true|false}]"
---

# Demo Scaffolding Implementation Plan

* ${input:chat:true}: (Optional, defaults to true) Include conversation context for interactive planning.

---

Locate the most recent research document matching `demo-scaffolding` in `.copilot-tracking/research/` and create a 4-phase implementation plan. The plan must produce all 13 scaffolding files with commit checkpoints between phases.

## Plan Context

* **Source**: Research document in `.copilot-tracking/research/` produced by `/demo-scaffolding`
* **Azure resource group**: `rg-dev-125` (pre-deployed, referenced in documentation and talk track)
* **ADO organization**: `MngEnvMCAP675646`
* **ADO project**: `ProgramDemo-DevDay2026-DryRun2`
* **Starting state**: Only `README.md` and `.github/prompts/bootstrap-demo.prompt.md` exist; no ADO work items exist

## Phases

### Phase 1: Configuration Files (7 files, commit checkpoint)

Create all configuration files in this order:

1. `.gitignore` — combined Java + Node + IDE + OS ignore rules
2. `.vscode/mcp.json` — ADO MCP server config pointing to organization `MngEnvMCAP675646` and project `ProgramDemo-DevDay2026-DryRun2`, using `npx -y azure-devops-mcp`
3. `.github/copilot-instructions.md` — global Copilot context covering project overview, tech stack, bilingual EN/FR, WCAG 2.2, Ontario DS, commit format `AB#{id}`, branch format `feature/{id}-description`
4. `.github/instructions/ado-workflow.instructions.md` — `applyTo: **`, branching model, commit conventions, PR linking with `Fixes AB#{id}`
5. `.github/instructions/java.instructions.md` — `applyTo: backend/**`, Java 21, Spring Boot 3.x, Spring Data JPA, constructor injection, `@Valid` + Bean Validation, `ResponseEntity`, `ProblemDetail` (RFC 7807), Flyway, H2 local profile `MODE=MSSQLServer`, package `com.ontario.program`
6. `.github/instructions/react.instructions.md` — `applyTo: frontend/**`, React 18 + TypeScript + Vite (`server.port: 3000`), functional components with hooks, i18next EN/FR, Ontario DS CSS, WCAG 2.2 Level AA, `react-router-dom`, axios
7. `.github/instructions/sql.instructions.md` — `applyTo: database/**`, Azure SQL target, Flyway versioned migrations `V001__description.sql`, `NVARCHAR` for bilingual text, `IF NOT EXISTS` guards, `INT IDENTITY(1,1)` PKs, `DATETIME2` timestamps, seed data via `INSERT ... WHERE NOT EXISTS` (never MERGE), audit columns

**Commit checkpoint**: All 7 configuration files ready.

### Phase 2: Documentation Files (3 files, commit checkpoint)

Create all documentation files with valid YAML frontmatter (`title`, `description`):

1. `docs/architecture.md` — Mermaid C4/flowchart diagram: browsers → React App Service → Java API App Service → Azure SQL, plus Durable Functions, Logic Apps, AI Foundry as additional services in resource group `rg-dev-125`
2. `docs/data-dictionary.md` — Mermaid ER diagram with 3 tables (`program_type`, `program`, `notification`), all column specifications including data types and constraints, and 5 seed data program types in EN/FR
3. `docs/design-document.md` — 5 API endpoints (`POST /api/programs`, `GET /api/programs`, `GET /api/programs/{id}`, `PUT /api/programs/{id}/review`, `GET /api/program-types`) with request/response DTOs, Bean Validation, RFC 7807 error handling, and frontend component hierarchy

**Commit checkpoint**: All 3 documentation files ready.

### Phase 3: Operational Files (2 scripts, commit checkpoint)

Create both PowerShell scripts:

1. `scripts/Start-Local.ps1` — `param()` block with `-SkipBuild`, `-BackendOnly`, `-FrontendOnly`, `-UseAzureSql` switch parameters, help comments, backend on port 8080 (Spring Boot `local` profile with H2), frontend on port 3000 (Vite)
2. `scripts/Stop-Local.ps1` — kill processes on ports 8080 and 3000

**Commit checkpoint**: Both scripts ready.

### Phase 4: Talk Track (1 file, commit checkpoint)

Create the talk track at the repository root (not in `docs/`):

1. `TALK-TRACK.md` — complete 130-minute minute-by-minute demo script covering all 8 acts plus opening/closing, with:
   * Part 1 "Building From Zero" (minutes 0–70) and Part 2 "Closing the Loop" (minutes 70–130)
   * Cliffhanger at minute 70: citizen portal works but Ministry Portal is empty
   * Act 1 must include creating all ADO work items via MCP (no items exist beforehand)
   * Scripted presenter dialogue in blockquotes
   * `Demo actions:` bullet lists with minute markers
   * `Key beat:` and `Audience engagement point:` callouts
   * Tagged commit checkpoints (v0.1.0 through v1.0.0) with fast-forward recovery strategy
   * Risk mitigation table (Copilot errors, Azure failures, time overruns, connectivity)
   * Key numbers summary table at the end

**Commit checkpoint**: Talk track ready.

## Constraints

* **No TODOs or placeholders** — every file must be complete and production-ready
* **Valid YAML frontmatter** on all markdown files — `title` and `description` for docs, `description` and `applyTo` for instruction files
* **ADO work item creation** happens in Act 1 of the talk track via MCP — no items exist beforehand
* **Talk track style** must follow the formatting requirements (blockquote dialogue, demo actions with minute markers, key beat/audience engagement callouts, commit checkpoints, risk mitigation table, key numbers table)
* **Azure references**: resource group `rg-dev-125`, ADO org `MngEnvMCAP675646`, project `ProgramDemo-DevDay2026-DryRun2`
* **`TALK-TRACK.md`** lives at the repository root, not in `docs/`
* **Mermaid diagrams** must use valid syntax in architecture and data-dictionary files
* **PowerShell scripts** must use `param()` blocks with help comments

## Out of Scope

* Document upload functionality
* `.devcontainer/devcontainer.json`
* Azure Durable Functions orchestration code
* Logic Apps connector configuration
* AI Foundry integration code
* CD deployment workflow
