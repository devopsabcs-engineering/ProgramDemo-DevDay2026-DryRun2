---
description: "Researches all scaffolding files for the OPS Program Approval demo — produces a comprehensive research document that drives planning and implementation"
agent: Task Researcher
argument-hint: "topic=demo-scaffolding"
---

# Demo Scaffolding Research

* ${input:topic:demo-scaffolding}: (Optional, defaults to demo-scaffolding) Research topic identifier.

---

Research everything needed to scaffold the OPS Program Approval demo application. Read `README.md` at the repository root for business context and tech stack, then produce a comprehensive research document in `.copilot-tracking/research/` covering every file listed below. Each section must contain enough detail that `/task-plan` can produce a file-by-file implementation plan without further clarification.

## Starting State

Only two files exist in the repository:

1. `README.md` — the single source of truth for the business problem and tech stack
2. `.github/prompts/bootstrap-demo.prompt.md` — the bootstrap prompt that generated this file

Nothing else exists: no code, no documentation, no configuration files, no scripts, and no ADO work items. All ADO work items must be created via MCP during the live demo (Act 1).

## Demo Context

* **Duration**: 130 minutes (two parts separated by a cliffhanger at minute 70)
* **Audience**: Ontario Public Sector (OPS) developers and leadership
* **Goal**: Showcase GitHub Copilot building a full-stack Program Approval web application from scratch
* **Azure**: Resources pre-deployed in resource group `rg-dev-125`
* **ADO**: Organization `MngEnvMCAP675646`, Project `ProgramDemo-DevDay2026-DryRun2`

## Files to Cover in the Research Document

### Configuration layer (7 files)

| File                                                  | Purpose                                                                                                                                                                                                                                                              |
|-------------------------------------------------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `.gitignore`                                          | Java + Node + IDE + OS ignore rules                                                                                                                                                                                                                                  |
| `.vscode/mcp.json`                                    | ADO MCP server config — command: `npx`, args: `-y azure-devops-mcp --organization MngEnvMCAP675646 --project ProgramDemo-DevDay2026-DryRun2`                                                                                                                         |
| `.github/copilot-instructions.md`                     | Global Copilot context: project overview, tech stack, bilingual EN/FR, WCAG 2.2, Ontario DS, commit format `AB#{id}`, branch format `feature/{id}-description`                                                                                                       |
| `.github/instructions/ado-workflow.instructions.md`   | `applyTo: **` — branching, commit, PR conventions for ADO                                                                                                                                                                                                            |
| `.github/instructions/java.instructions.md`           | `applyTo: backend/**` — Java 21, Spring Boot 3.x, Spring Data JPA, constructor injection, `@Valid` + Bean Validation, `ResponseEntity`, `ProblemDetail` (RFC 7807), Flyway, H2 local profile with `MODE=MSSQLServer`, package `com.ontario.program`                   |
| `.github/instructions/react.instructions.md`          | `applyTo: frontend/**` — React 18 + TypeScript + Vite (`server.port: 3000`), functional components with hooks, i18next for EN/FR, Ontario DS CSS classes, WCAG 2.2 Level AA (`aria-*`, semantic HTML, keyboard nav, `lang` attribute), `react-router-dom`, axios      |
| `.github/instructions/sql.instructions.md`            | `applyTo: database/**` — Azure SQL target, Flyway versioned migrations `V001__description.sql`, `NVARCHAR` for bilingual text, `IF NOT EXISTS` guards, `INT IDENTITY(1,1)` PKs, `DATETIME2` timestamps, seed data via `INSERT ... WHERE NOT EXISTS` (never MERGE)    |

### Documentation layer (3 files)

| File                      | Purpose                                                                                                             |
|---------------------------|---------------------------------------------------------------------------------------------------------------------|
| `docs/architecture.md`    | Mermaid C4/flowchart: browsers → React App Service → Java API App Service → Azure SQL; also Durable Functions, Logic Apps, AI Foundry |
| `docs/data-dictionary.md` | Mermaid ER diagram, 3 tables (`program_type`, `program`, `notification`), all column details, seed data             |
| `docs/design-document.md` | 5 API endpoints, request/response DTOs with validation, RFC 7807 error handling, frontend component hierarchy       |

### Operational layer (3 files)

| File                    | Purpose                                                                                                          |
|-------------------------|------------------------------------------------------------------------------------------------------------------|
| `TALK-TRACK.md`         | 130-minute minute-by-minute demo script at the **repository root** (not in `docs/`)                              |
| `scripts/Start-Local.ps1` | PowerShell with `-SkipBuild`, `-BackendOnly`, `-FrontendOnly`, `-UseAzureSql` params; backend port 8080, frontend port 3000 |
| `scripts/Stop-Local.ps1`  | Kill processes on ports 8080 and 3000                                                                            |

## Required Sections in the Research Output

### 1. Copilot Instructions Specification

Produce a table of all instruction files with `applyTo` glob patterns and detailed content summaries. Cover every convention, standard, and pattern that each file must define:

* `.github/copilot-instructions.md` — project overview, tech stack summary, bilingual EN/FR requirement, WCAG 2.2 Level AA, Ontario Design System, commit message format `AB#{id} <description>`, branch naming `feature/{id}-description`, PR format `Fixes AB#{id}`
* `.github/instructions/ado-workflow.instructions.md` — `applyTo: **`, branching model, commit conventions, PR linking, post-merge cleanup
* `.github/instructions/java.instructions.md` — `applyTo: backend/**`, Java 21, Spring Boot 3.x, Spring Data JPA, constructor injection (no field injection), `@Valid` + Bean Validation on DTOs, `ResponseEntity` return types, `ProblemDetail` for RFC 7807 error responses, Flyway migrations, H2 local profile with `MODE=MSSQLServer`, base package `com.ontario.program`
* `.github/instructions/react.instructions.md` — `applyTo: frontend/**`, React 18, TypeScript strict mode, Vite with `server.port: 3000`, functional components with hooks only, i18next with `en.json`/`fr.json` translation files, Ontario DS CSS classes, WCAG 2.2 Level AA (`aria-*` attributes, semantic HTML, keyboard navigation, `lang` attribute on `<html>`), `react-router-dom` for routing, axios for HTTP
* `.github/instructions/sql.instructions.md` — `applyTo: database/**`, Azure SQL target, Flyway versioned migrations named `V001__description.sql`, `NVARCHAR` for all bilingual text columns, `IF NOT EXISTS` guards on DDL, `INT IDENTITY(1,1)` primary keys, `DATETIME2` for all timestamps, seed data via `INSERT ... WHERE NOT EXISTS` (never use MERGE), audit columns (`created_at`, `updated_at`, `created_by` where applicable)

### 2. MCP Configuration

Document the full `.vscode/mcp.json` structure:

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "azure-devops-mcp", "--organization", "MngEnvMCAP675646", "--project", "ProgramDemo-DevDay2026-DryRun2"]
    }
  }
}
```

### 3. ADO Work Item Creation Plan

No ADO work items exist at the start of the demo. All must be created via MCP during Act 1. Document the full hierarchy:

* **Epic**: OPS Program Approval System
  * **Feature**: Infrastructure Setup (pre-deployed in `rg-dev-125`, close immediately after creation)
  * **Feature**: Database Layer
    * Story: Create program_type table
    * Story: Create program table
    * Story: Create notification table
    * Story: Insert seed data
  * **Feature**: Backend API
    * Story: Spring Boot project scaffolding
    * Story: Submit program endpoint (`POST /api/programs`)
    * Story: List and get program endpoints (`GET /api/programs`, `GET /api/programs/{id}`)
    * Story: Review program endpoint (`PUT /api/programs/{id}/review`)
    * Story: Program types endpoint (`GET /api/program-types`)
  * **Feature**: Citizen Portal
    * Story: React project scaffolding with Vite
    * Story: Ontario DS layout (Header, Footer, LanguageToggle)
    * Story: Program submission form
    * Story: Submission confirmation page
    * Story: Program search page
    * Story: Bilingual EN/FR support with i18next
  * **Feature**: Ministry Portal
    * Story: Review dashboard page
    * Story: Review detail page
    * Story: Approve/reject actions
  * **Feature**: Quality Assurance
    * Story: Backend controller tests
    * Story: Frontend component tests
    * Story: Accessibility tests
    * Story: Bilingual verification
  * **Feature**: CI/CD Pipeline
    * Story: CI workflow (GitHub Actions)
    * Story: Dependabot config
    * Story: Secret scanning
  * **Feature**: Live Change Demo
    * Story: Add program_budget field end-to-end
    * Story: Update tests for new field

### 4. Documentation Specifications

#### Architecture (`docs/architecture.md`)

* Mermaid C4 or flowchart showing: browsers → React App Service → Java API App Service → Azure SQL
* Include Durable Functions, Logic Apps, and AI Foundry as additional Azure services in the diagram
* Resource group `rg-dev-125`
* Valid YAML frontmatter with `title` and `description`

#### Data Dictionary (`docs/data-dictionary.md`)

* Mermaid ER diagram showing relationships between all 3 tables
* **`program_type`** table — simple lookup, no audit columns:
  * `id` INT IDENTITY(1,1) PK
  * `type_name` NVARCHAR(100)
  * `type_name_fr` NVARCHAR(100)
* **`program`** table — with audit columns:
  * `id` INT IDENTITY(1,1) PK
  * `program_name` NVARCHAR(200)
  * `program_description` NVARCHAR(MAX)
  * `program_type_id` INT FK → program_type.id
  * `status` NVARCHAR(20) DEFAULT 'DRAFT'
  * `reviewer_comments` NVARCHAR(MAX)
  * `submitted_at` DATETIME2
  * `reviewed_at` DATETIME2
  * `created_at` DATETIME2
  * `updated_at` DATETIME2
  * `created_by` NVARCHAR(100)
* **`notification`** table — system-generated, no `created_by`:
  * `id` INT IDENTITY(1,1) PK
  * `program_id` INT FK → program.id
  * `notification_type` NVARCHAR(50)
  * `recipient_email` NVARCHAR(200)
  * `subject` NVARCHAR(500)
  * `body` NVARCHAR(MAX)
  * `sent_at` DATETIME2
  * `created_at` DATETIME2
  * `updated_at` DATETIME2 DEFAULT GETDATE()
  * `status` NVARCHAR(20)
* Seed data — 5 program types (EN/FR):
  1. Community Services / Services communautaires
  2. Health & Wellness / Santé et bien-être
  3. Education & Training / Éducation et formation
  4. Environment & Conservation / Environnement et conservation
  5. Economic Development / Développement économique

#### Design Document (`docs/design-document.md`)

* 5 API endpoints with HTTP method, path, request body, response body, status codes:
  1. `POST /api/programs` — submit a program
  2. `GET /api/programs` — list all programs
  3. `GET /api/programs/{id}` — get a single program
  4. `PUT /api/programs/{id}/review` — approve or reject
  5. `GET /api/program-types` — dropdown values
* Request/response DTOs with Bean Validation annotations
* RFC 7807 `ProblemDetail` error response format
* Frontend component hierarchy: Layout (Header, Footer, LanguageToggle) → pages (SubmitProgram, SubmitConfirmation, SearchPrograms, ReviewDashboard, ReviewDetail)

### 5. Talk Track Structure

Document the complete 130-minute structure for `TALK-TRACK.md` (placed at the repository root, not in `docs/`):

**Part 1: "Building From Zero" (Minutes 0–70)**

| Minutes | Act                          | Role          | Content                                                                                 |
|---------|------------------------------|---------------|-----------------------------------------------------------------------------------------|
| 0–8     | Opening                      | Presenter     | The Problem — show empty repo, Azure portal (`rg-dev-125`), empty ADO board             |
| 8–20    | Act 1: The Architect         | Architect     | Run scaffolding prompts, configure MCP, create ADO Epic/Features/Stories via MCP         |
| 20–32   | Act 2: The DBA               | DBA           | 4 Flyway SQL migrations: program_type, program, notification, seed data                 |
| 32–52   | Act 3: The Backend Developer | Backend Dev   | Spring Boot scaffolding + 5 API endpoints + live curl tests                             |
| 52–70   | Act 4: The Frontend Developer| Frontend Dev  | React + Ontario DS + bilingual citizen portal + live form submission                     |

**Cliffhanger (Minute 70)**: Citizen can submit programs but Ministry Portal is empty. Show ADO board with unstarted Ministry stories.

**Part 2: "Closing the Loop" (Minutes 70–130)**

| Minutes | Act                           | Role        | Content                                                                             |
|---------|-------------------------------|-------------|------------------------------------------------------------------------------------- |
| 70–73   | Recap                         | Presenter   | Quick recap, show database with submissions                                          |
| 73–87   | Act 5: Completing the Story   | Frontend Dev| Ministry review dashboard, detail, approve/reject                                    |
| 87–100  | Act 6: The QA Engineer        | QA          | Backend controller tests, frontend component tests, accessibility                    |
| 100–107 | Act 7: The DevOps Engineer    | DevOps      | CI pipeline, Dependabot, secret scanning, GHAS                                       |
| 107–120 | Act 8: The Full Stack Change  | Full Stack  | Add `program_budget` field: migration → entity → DTO → API → form → tests            |
| 120–130 | Closing                       | Presenter   | Summary stats, ADO board all done, Q&A                                               |

**Formatting requirements** for the talk track:

* Scripted presenter dialogue in blockquotes
* `Demo actions:` bullet lists with minute markers
* `Key beat:` and `Audience engagement point:` callouts
* Tagged commit checkpoints (v0.1.0 through v1.0.0) with fast-forward recovery strategy
* Risk mitigation table (Copilot errors, Azure failures, time overruns, connectivity)
* Key numbers summary table at the end

### 6. Local Development Scripts

#### `scripts/Start-Local.ps1`

* `param()` block with switch parameters: `-SkipBuild`, `-BackendOnly`, `-FrontendOnly`, `-UseAzureSql`
* Backend: port 8080, Spring Boot with `local` profile (H2 with `MODE=MSSQLServer`)
* Frontend: port 3000, Vite dev server
* Help comments describing each parameter

#### `scripts/Stop-Local.ps1`

* Kill processes on ports 8080 and 3000
* Cross-platform port detection using `Get-NetTCPConnection` or equivalent

### 7. `.gitignore`

Combined rules covering:

* Java: `target/`, `*.class`, `*.jar`, `*.war`, `.gradle/`, `build/`
* Node: `node_modules/`, `dist/`, `.env`, `.env.local`
* IDE: `.idea/`, `.vscode/settings.json`, `*.iml`, `.project`, `.classpath`
* OS: `.DS_Store`, `Thumbs.db`, `desktop.ini`

## Out of Scope

These items are explicitly excluded from the research:

* Document upload functionality (README.md marks as optional)
* `.devcontainer/devcontainer.json`
* Azure Durable Functions orchestration code
* Logic Apps connector configuration
* AI Foundry integration code
* CD deployment workflow

## Success Criteria

The research document must be detailed enough that running `/task-plan` produces a complete, file-by-file implementation plan covering all 13 files (7 configuration + 3 documentation + 2 scripts + TALK-TRACK.md) without any follow-up questions or missing details.
