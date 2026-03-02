---
description: "Executes the 4-phase implementation plan to create all 13 demo scaffolding files with phase-stop for review and commit at each checkpoint"
agent: Task Implementor
argument-hint: "[phaseStop={true|false}]"
---

# Demo Scaffolding Implementation

* ${input:phaseStop:true}: (Optional, defaults to true) Pause after each phase for user review and commit.

---

Locate the most recent implementation plan matching `demo-scaffolding` in `.copilot-tracking/plans/` and execute it phase by phase. When `phaseStop` is true, pause after each phase so the user can review the generated files and commit before proceeding.

## Implementation Context

* **Source**: Implementation plan in `.copilot-tracking/plans/` produced by `/demo-scaffolding-plan`
* **Research**: Research document in `.copilot-tracking/research/` produced by `/demo-scaffolding`
* **Azure resource group**: `rg-dev-125` (pre-deployed)
* **ADO organization**: `MngEnvMCAP675646`
* **ADO project**: `ProgramDemo-DevDay2026-DryRun2`
* **Starting state**: Only `README.md` and `.github/prompts/` files exist; no ADO work items exist

## Phase Execution

Execute each phase from the implementation plan, creating all files with complete content. Read the research document for detailed specifications of every file.

### Phase 1: Configuration Files (7 files)

Create these files with complete, production-ready content:

1. `.gitignore` — combined Java (`target/`, `*.class`, `*.jar`, `*.war`, `.gradle/`, `build/`) + Node (`node_modules/`, `dist/`, `.env`, `.env.local`) + IDE (`.idea/`, `.vscode/settings.json`, `*.iml`) + OS (`.DS_Store`, `Thumbs.db`)
2. `.vscode/mcp.json` — ADO MCP server: `npx -y azure-devops-mcp --organization MngEnvMCAP675646 --project ProgramDemo-DevDay2026-DryRun2`
3. `.github/copilot-instructions.md` — global Copilot context with project overview, tech stack, bilingual EN/FR, WCAG 2.2, Ontario DS, commit format `AB#{id}`, branch format `feature/{id}-description`
4. `.github/instructions/ado-workflow.instructions.md` — `applyTo: **`, branching model, commit conventions, PR linking
5. `.github/instructions/java.instructions.md` — `applyTo: backend/**`, Java 21, Spring Boot 3.x, Spring Data JPA, constructor injection, `@Valid`, `ResponseEntity`, `ProblemDetail` (RFC 7807), Flyway, H2 `MODE=MSSQLServer`, package `com.ontario.program`
6. `.github/instructions/react.instructions.md` — `applyTo: frontend/**`, React 18 + TypeScript + Vite (`server.port: 3000`), hooks, i18next, Ontario DS, WCAG 2.2 Level AA, `react-router-dom`, axios
7. `.github/instructions/sql.instructions.md` — `applyTo: database/**`, Azure SQL, Flyway `V001__description.sql`, `NVARCHAR`, `IF NOT EXISTS`, `INT IDENTITY(1,1)`, `DATETIME2`, `INSERT ... WHERE NOT EXISTS` (never MERGE)

**Checkpoint**: Pause for review and commit if `phaseStop` is true.

### Phase 2: Documentation Files (3 files)

Create these files with valid YAML frontmatter (`title`, `description`) and valid Mermaid diagrams:

1. `docs/architecture.md` — Mermaid C4/flowchart: browsers → React App Service → Java API App Service → Azure SQL, plus Durable Functions, Logic Apps, AI Foundry in `rg-dev-125`
2. `docs/data-dictionary.md` — Mermaid ER diagram with 3 tables and all column specifications:
   * `program_type`: `id` INT PK, `type_name` NVARCHAR(100), `type_name_fr` NVARCHAR(100) — no audit columns
   * `program`: `id` INT PK, `program_name` NVARCHAR(200), `program_description` NVARCHAR(MAX), `program_type_id` INT FK, `status` NVARCHAR(20) DEFAULT 'DRAFT', `reviewer_comments` NVARCHAR(MAX), `submitted_at` DATETIME2, `reviewed_at` DATETIME2, `created_at` DATETIME2, `updated_at` DATETIME2, `created_by` NVARCHAR(100)
   * `notification`: `id` INT PK, `program_id` INT FK, `notification_type` NVARCHAR(50), `recipient_email` NVARCHAR(200), `subject` NVARCHAR(500), `body` NVARCHAR(MAX), `sent_at` DATETIME2, `created_at` DATETIME2, `updated_at` DATETIME2 DEFAULT GETDATE(), `status` NVARCHAR(20) — no `created_by`
   * Seed data: 5 program types EN/FR (Community Services / Services communautaires, Health & Wellness / Santé et bien-être, Education & Training / Éducation et formation, Environment & Conservation / Environnement et conservation, Economic Development / Développement économique)
3. `docs/design-document.md` — 5 API endpoints with request/response DTOs, Bean Validation, RFC 7807 errors, frontend component hierarchy (Layout → SubmitProgram, SubmitConfirmation, SearchPrograms, ReviewDashboard, ReviewDetail)

**Checkpoint**: Pause for review and commit if `phaseStop` is true.

### Phase 3: Operational Files (2 scripts)

Create both PowerShell scripts with `param()` blocks and help comments:

1. `scripts/Start-Local.ps1` — parameters: `-SkipBuild` (skip Maven/npm build), `-BackendOnly` (only Spring Boot on port 8080), `-FrontendOnly` (only Vite on port 3000), `-UseAzureSql` (connect to Azure SQL instead of H2). Default runs both backend (H2 with `MODE=MSSQLServer`) and frontend.
2. `scripts/Stop-Local.ps1` — find and kill processes on ports 8080 and 3000 using `Get-NetTCPConnection` or equivalent

**Checkpoint**: Pause for review and commit if `phaseStop` is true.

### Phase 4: Talk Track (1 file)

Create `TALK-TRACK.md` at the **repository root** (not in `docs/`) covering all 130 minutes with no gaps:

**Part 1: "Building From Zero" (Minutes 0–70)**

* Minutes 0–8: Opening — show empty repo (only `README.md` + `bootstrap-demo.prompt.md`), Azure portal (`rg-dev-125`), empty ADO board
* Minutes 8–20: Act 1 The Architect — run scaffolding prompts, configure MCP, **create all ADO work items via MCP** (Epic, Features, Stories — none exist beforehand)
* Minutes 20–32: Act 2 The DBA — 4 Flyway SQL migrations (program_type, program, notification, seed data)
* Minutes 32–52: Act 3 The Backend Developer — Spring Boot scaffolding + 5 API endpoints + live curl tests
* Minutes 52–70: Act 4 The Frontend Developer — React + Ontario DS + bilingual citizen portal + live form submission

**Cliffhanger (Minute 70)**: Citizen can submit programs but Ministry Portal is empty. Show ADO board with unstarted Ministry stories.

**Part 2: "Closing the Loop" (Minutes 70–130)**

* Minutes 70–73: Recap — quick recap, show database with submissions
* Minutes 73–87: Act 5 Completing the Story — Ministry review dashboard, detail, approve/reject
* Minutes 87–100: Act 6 The QA Engineer — backend controller tests, frontend component tests, accessibility
* Minutes 100–107: Act 7 The DevOps Engineer — CI pipeline, Dependabot, secret scanning, GHAS
* Minutes 107–120: Act 8 The Full Stack Change — add `program_budget` field: migration → entity → DTO → API → form → tests
* Minutes 120–130: Closing — summary stats, ADO board all done, Q&A

**Required formatting**:

* Scripted presenter dialogue in blockquotes
* `Demo actions:` bullet lists with minute markers
* `Key beat:` and `Audience engagement point:` callouts
* Tagged commit checkpoints (v0.1.0 through v1.0.0) with fast-forward recovery strategy
* Risk mitigation table (Copilot errors, Azure failures, time overruns, connectivity)
* Key numbers summary table at the end

**Checkpoint**: Pause for review and commit if `phaseStop` is true.

## Quality Gates

Every file must pass these checks before the phase is complete:

* **No TODOs or placeholders** — all content is complete and production-ready
* **Valid YAML frontmatter** on all markdown files — `title` and `description` for docs, `description` and `applyTo` for instruction files
* **Valid Mermaid syntax** in `docs/architecture.md` and `docs/data-dictionary.md`
* **`TALK-TRACK.md`** covers all 130 minutes with no time gaps between acts
* **Act 1** includes ADO work item creation via MCP (no items exist beforehand)
* **PowerShell scripts** use `param()` blocks with help comments
* **`.gitignore`** covers Java, Node, IDE, and OS artifacts
* **Instruction files** include both `description` and `applyTo` in frontmatter

## Out of Scope

* Document upload functionality
* `.devcontainer/devcontainer.json`
* Azure Durable Functions orchestration code
* Logic Apps connector configuration
* AI Foundry integration code
* CD deployment workflow
