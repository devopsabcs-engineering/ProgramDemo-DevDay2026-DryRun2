---
description: "Generates 3 HVE-Core prompt files (research → plan → implement) that scaffold a 130-minute OPS GitHub Copilot demo from README.md alone"
---

# Generate Demo Scaffolding Prompts

Create 3 paste-and-run prompt files that drive the HVE-Core `/task-research` → `/task-plan` → `/task-implement` workflow. Together, these prompts generate all scaffolding files and a 130-minute talk track for a live GitHub Copilot demo for the Ontario Public Sector (Developer Day 2026 — Dry Run 1).

## Demo Context

* **Duration**: 130 minutes
* **Audience**: Ontario Public Sector (OPS) developers and leadership
* **Goal**: Showcase GitHub Copilot building a full-stack Program Approval web application from scratch
* **Azure**: Resources pre-deployed in resource group `rg-dev-125` (prompt-provided context, not in README.md)
* **ADO**: Organization `MngEnvMCAP675646`, Project `ProgramDemo-DevDay2026-DryRun2`
* **Reference application**: Same application defined in `README.md` (this repo)
* **Talk track style reference**: use only the formatting requirements in the Talk Track Formatting Requirements section below

## Starting State (What Exists When the Demo Begins)

Only two things exist in the repository:

1. `README.md` — the single source of truth for the business problem and tech stack
2. `.github/prompts/bootstrap-demo.prompt.md` — this prompt file (generates the 3 HVE-Core prompts as the first step of the demo)

**Nothing else exists:**

* No code, no documentation, no configuration files, no scripts
* **No ADO work items** — no Epic, no Features, no User Stories — all must be created via MCP during the demo

## Files to Generate During the Live Demo

### Configuration layer (generated first via scaffolding prompts)

| File | Purpose |
|------|---------|
| `.gitignore` | Java + Node + IDE + OS ignore rules |
| `.vscode/mcp.json` | ADO MCP server config — `npx -y azure-devops-mcp --organization MngEnvMCAP675646 --project ProgramDemo-DevDay2026-DryRun2` |
| `.github/copilot-instructions.md` | Global Copilot context: project overview, tech stack, bilingual EN/FR, WCAG 2.2, Ontario DS, commit format `AB#{id}`, branch format `feature/{id}-description` |
| `.github/instructions/ado-workflow.instructions.md` | `applyTo: **` — branching, commit, PR conventions for ADO |
| `.github/instructions/java.instructions.md` | `applyTo: backend/**` — Java 21, Spring Boot 3.x, Spring Data JPA, constructor injection, `@Valid` + Bean Validation, `ResponseEntity`, `ProblemDetail` (RFC 7807), Flyway, H2 local profile with `MODE=MSSQLServer`, package `com.ontario.program` |
| `.github/instructions/react.instructions.md` | `applyTo: frontend/**` — React 18 + TypeScript + Vite (`server.port: 3000`), functional components with hooks, i18next for EN/FR, Ontario DS CSS classes, WCAG 2.2 Level AA (`aria-*`, semantic HTML, keyboard nav, `lang` attribute), `react-router-dom`, axios |
| `.github/instructions/sql.instructions.md` | `applyTo: database/**` — Azure SQL target, Flyway versioned migrations `V001__description.sql`, `NVARCHAR` for bilingual text, `IF NOT EXISTS` guards, `INT IDENTITY(1,1)` PKs, `DATETIME2` timestamps, seed data via `INSERT ... WHERE NOT EXISTS` (never MERGE), audit columns |

### Documentation layer

| File | Purpose |
|------|---------|
| `docs/architecture.md` | Mermaid C4/flowchart: browsers → React App Service → Java API App Service → Azure SQL; also shows Durable Functions, Logic Apps, AI Foundry |
| `docs/data-dictionary.md` | Mermaid ER diagram, 3 tables (`program_type`, `program`, `notification`), seed data (5 program types EN/FR) |
| `docs/design-document.md` | 5 API endpoints, request/response DTOs with validation, RFC 7807 error handling, frontend component hierarchy |

### Operational layer

| File | Purpose |
|------|---------|
| `TALK-TRACK.md` | 130-minute minute-by-minute demo script at the **repository root** (not in `docs/`) |
| `scripts/Start-Local.ps1` | PowerShell with `-SkipBuild`, `-BackendOnly`, `-FrontendOnly`, `-UseAzureSql` params; backend port 8080, frontend port 3000 |
| `scripts/Stop-Local.ps1` | Kill processes on ports 8080 and 3000 |

## Critical Technical Details

These details are NOT in README.md but must appear in the generated prompts.

### Database

* `program_type` is a simple lookup table — columns: `id` (INT PK), `type_name` (NVARCHAR(100)), `type_name_fr` (NVARCHAR(100)). No audit columns needed for static reference data.
* `program` columns: `id` (INT PK), `program_name` (NVARCHAR(200)), `program_description` (NVARCHAR(MAX)), `program_type_id` (INT FK), `status` (NVARCHAR(20) default 'DRAFT'), `reviewer_comments` (NVARCHAR(MAX)), `submitted_at` (DATETIME2), `reviewed_at` (DATETIME2), `created_at` (DATETIME2), `updated_at` (DATETIME2), `created_by` (NVARCHAR(100))
* `notification` columns: `id` (INT PK), `program_id` (INT FK), `notification_type` (NVARCHAR(50)), `recipient_email` (NVARCHAR(200)), `subject` (NVARCHAR(500)), `body` (NVARCHAR(MAX)), `sent_at` (DATETIME2), `created_at` (DATETIME2), `updated_at` (DATETIME2 DEFAULT GETDATE()), `status` (NVARCHAR(20))
* `program` includes `created_at`, `updated_at`, `created_by` audit columns; `notification` includes `created_at`, `updated_at` audit columns (no `created_by` — notifications are system-generated)
* Seed data uses `INSERT ... WHERE NOT EXISTS` pattern — portable across H2 and Azure SQL (never use MERGE)
* 5 program types (EN/FR): Community Services / Services communautaires, Health & Wellness / Santé et bien-être, Education & Training / Éducation et formation, Environment & Conservation / Environnement et conservation, Economic Development / Développement économique
* H2 local profile must use `MODE=MSSQLServer` for Azure SQL compatibility

### API (5 Endpoints)

1. `POST /api/programs` — submit a program
2. `GET /api/programs` — list programs
3. `GET /api/programs/{id}` — get single program
4. `PUT /api/programs/{id}/review` — approve/reject
5. `GET /api/program-types` — dropdown values

### Frontend

* Vite default port is 5173 — `vite.config.ts` must set `server.port: 3000`
* Component hierarchy: Layout (Header, Footer, LanguageToggle) → pages (SubmitProgram, SubmitConfirmation, SearchPrograms, ReviewDashboard, ReviewDetail)

### ADO Work Items (Created via MCP During Act 1 — None Exist Beforehand)

* **Epic**: OPS Program Approval System
  * **Feature**: Infrastructure Setup (pre-deployed in `rg-dev-125`, close immediately)
  * **Feature**: Database Layer — Stories: program_type table, program table, notification table, seed data
  * **Feature**: Backend API — Stories: Spring Boot scaffolding, submit endpoint, list/get endpoints, review endpoint, program-types endpoint
  * **Feature**: Citizen Portal — Stories: React scaffolding, Ontario DS layout, submission form, confirmation page, search page, bilingual EN/FR
  * **Feature**: Ministry Portal — Stories: review dashboard, review detail page, approve/reject actions
  * **Feature**: Quality Assurance — Stories: backend controller tests, frontend component tests, accessibility tests, bilingual verification
  * **Feature**: CI/CD Pipeline — Stories: CI workflow, Dependabot config, secret scanning
  * **Feature**: Live Change Demo — Stories: add program_budget field end-to-end, update tests for new field

## Talk Track Structure (130 Minutes)

### Part 1: "Building From Zero" (Minutes 0–70)

| Minutes | Act | Role | Content |
|---------|-----|------|---------|
| 0–8 | Opening | Presenter | The Problem — show empty repo (only README.md + bootstrap-demo.prompt.md), Azure portal (`rg-dev-125`), empty ADO board |
| 8–20 | Act 1: The Architect | Architect | Run scaffolding prompts to generate config/docs/scripts; configure MCP; **create ADO Epic/Features/Stories via MCP** |
| 20–32 | Act 2: The DBA | DBA | 4 Flyway SQL migrations: program_type, program, notification, seed data |
| 32–52 | Act 3: The Backend Developer | Backend Dev | Spring Boot scaffolding + 5 API endpoints + live curl tests |
| 52–70 | Act 4: The Frontend Developer | Frontend Dev | React + Ontario DS + bilingual citizen portal + live form submission |

### Cliffhanger (Minute 70)

Citizen can submit programs but Ministry Portal is empty — nobody can approve. Show ADO board with unstarted Ministry stories.

### Part 2: "Closing the Loop" (Minutes 70–130)

| Minutes | Act | Role | Content |
|---------|-----|------|---------|
| 70–73 | Recap | Presenter | Quick recap, show database with submissions |
| 73–87 | Act 5: Completing the Story | Frontend Dev | Ministry review dashboard, detail, approve/reject |
| 87–100 | Act 6: The QA Engineer | QA | Backend controller tests, frontend component tests, accessibility |
| 100–107 | Act 7: The DevOps Engineer | DevOps | CI pipeline, Dependabot, secret scanning, GHAS |
| 107–120 | Act 8: The Full Stack Change | Full Stack | Add `program_budget` field: migration → entity → DTO → API → form → tests |
| 120–130 | Closing | Presenter | Summary stats, ADO board all done, Q&A |

### Talk Track Formatting Requirements

* Scripted presenter dialogue in blockquotes
* `Demo actions:` bullet lists with minute markers
* `Key beat:` and `Audience engagement point:` callouts
* Tagged commit checkpoints (v0.1.0 through v1.0.0) with fast-forward recovery strategy
* Risk mitigation table (Copilot errors, Azure failures, time overruns, connectivity)
* Key numbers summary table at the end

## Out of Scope

* Document upload functionality (README.md marks as optional)
* `.devcontainer/devcontainer.json`
* Azure Durable Functions orchestration code
* Logic Apps connector configuration
* AI Foundry integration code
* CD deployment workflow

---

## Prompt Files to Create

### Prompt 1: `.github/prompts/demo-scaffolding.prompt.md`

| Property | Value |
|----------|-------|
| Agent | Task Researcher |
| argument-hint | `topic=demo-scaffolding` |
| Input | `${input:topic:demo-scaffolding}` |

**Purpose**: Read `README.md` and produce a comprehensive research document in `.copilot-tracking/research/` covering all files listed above. Each section must contain enough detail that `/task-plan` can produce a file-by-file implementation plan without further clarification.

**Required sections in the research output**:

1. Copilot Instructions Specification — table of all instruction files with `applyTo` patterns and content summaries
2. MCP Configuration — full `.vscode/mcp.json` content spec
3. ADO Work Item Creation Plan — full hierarchy (no items exist; must be created via MCP in Act 1)
4. Documentation Specifications — architecture (Mermaid C4), data-dictionary (Mermaid ER, all column details), design-document (5 API endpoints, DTOs, component hierarchy)
5. Talk Track — complete 130-minute structure with all acts, cliffhanger, formatting rules
6. Local Development Scripts — `Start-Local.ps1` with `-SkipBuild`, `-BackendOnly`, `-FrontendOnly`, `-UseAzureSql` params; `Stop-Local.ps1`
7. `.gitignore` — combined Java + Node + IDE + OS rules

Plus an **Out of Scope** section and **Success Criteria**.

The prompt must state clearly: scaffolding is generated during the live demo, no ADO work items exist, only README.md and bootstrap-demo.prompt.md exist at start, and `TALK-TRACK.md` goes at the repository root.

### Prompt 2: `.github/prompts/demo-scaffolding-plan.prompt.md`

| Property | Value |
|----------|-------|
| Agent | Task Planner |
| argument-hint | `[chat={true\|false}]` |
| Input | `${input:chat:true}` |

**Purpose**: Locate the research document in `.copilot-tracking/research/` and create a 4-phase implementation plan.

**Phases**:

1. **Configuration Files** (7 files, commit checkpoint) — `.gitignore`, MCP config, copilot-instructions, 4 path-specific instruction files
2. **Documentation Files** (3 files, commit checkpoint) — architecture, data-dictionary, design-document
3. **Operational Files** (2 scripts, commit checkpoint) — Start-Local.ps1, Stop-Local.ps1
4. **Talk Track** (1 file, commit checkpoint) — `TALK-TRACK.md` at the repository root

**Constraints to encode**: no TODOs/placeholders, valid YAML frontmatter, `description` and `applyTo` on instruction files, ADO work item creation in Act 1, talk track style formatting, reference `rg-dev-125` and ADO org/project.

### Prompt 3: `.github/prompts/demo-scaffolding-implement.prompt.md`

| Property | Value |
|----------|-------|
| Agent | Task Implementor |
| argument-hint | `[phaseStop={true\|false}]` |
| Input | `${input:phaseStop:true}` |

**Purpose**: Execute the implementation plan with phase-stop for user review and commit at each checkpoint.

**Quality gates to encode**:

* Valid YAML frontmatter on all markdown files
* `description` and `applyTo` fields on instruction files
* Valid Mermaid syntax in documentation files
* `TALK-TRACK.md` covers all 130 minutes with no gaps
* Act 1 includes ADO work item creation via MCP (no items exist beforehand)
* PowerShell scripts use `param()` blocks with help comments
* `.gitignore` covers Java, Node, IDE artifacts

## Success Criteria

The 3 generated prompt files must be complete, self-contained, and paste-and-run. A user with only `README.md` and `bootstrap-demo.prompt.md` can generate the 3 prompts and then run them in sequence to produce all 13 scaffolding files (7 configuration + 3 documentation + 2 scripts + TALK-TRACK.md) without further prompt engineering.
