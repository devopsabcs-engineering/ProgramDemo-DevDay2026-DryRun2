# TALK-TRACK: OPS Program Approval Demo

**Total Duration:** 130 minutes  
**Presenter:** Developer Day 2026 Demo Team  
**Audience:** Ontario Public Service developers, architects, and IT leadership

---

## Part 1: Building From Zero (Minutes 0–70)

### Opening (Minutes 0–8)

> "Welcome to Developer Day 2026. Today we're going to build a complete government web application from scratch—bilingual, accessible, deployed to Azure—in about two hours. Everything you see from this point forward will be built by AI with GitHub Copilot."

**Key beat:** "Everything you see from this point was built by AI"

**Audience engagement point:** "How many of you have built a full-stack app in under 2 hours?"

**[Minute 0]** Open Visual Studio Code with empty repository

* Show file explorer—only `README.md` and `scripts/` folder visible
* **Expected output:** Empty workspace

**[Minute 2]** Open Azure Portal

* Navigate to resource group `rg-dev-125`
* Show pre-deployed infrastructure: App Services, Azure SQL, Function Apps
* **Expected output:** 6 Azure resources visible in resource group

**[Minute 5]** Open Azure DevOps Board

* Navigate to `ProgramDemo-DevDay2026-DryRun2` project
* Show empty backlog (no work items yet)
* **Expected output:** Empty board view

> "We have infrastructure ready and an empty backlog. Let's start building."

---

### Act 1: The Architect (Minutes 8–20)

> "First, let's put on our architect hat. We need to establish the project foundation—configuration files, coding standards, and work items."

**[Minute 8]** Run scaffolding prompt

* Open Copilot Chat
* Type: `@workspace /prompt demo-scaffolding`
* Watch Copilot generate 13 scaffolding files
* **Expected output:** `.gitignore`, instruction files, documentation, scripts created

**[Minute 12]** Show generated files

* Walk through key files:
  * `.github/copilot-instructions.md` — project context for AI
  * `.github/instructions/java.instructions.md` — backend conventions
  * `docs/architecture.md` — system diagram
* **Expected output:** Files visible in explorer with correct content

**[Minute 15]** Create ADO work items via MCP

* Copilot creates Epic, Features, Stories via MCP tool
* **Expected output:** 36 work items created (1 Epic + 8 Features + 27 Stories)

**[Minute 18]** Show ADO Board

* Refresh Azure DevOps
* Show hierarchy: Epic → Features → Stories
* Note: Infrastructure Setup Feature already Closed (pre-deployed)
* **Expected output:** Full backlog visible with proper hierarchy

**[Minute 20]** Checkpoint

* `git add . && git commit -m "AB#1 Add project scaffolding"`
* `git tag v0.1.0`
* **Expected output:** Tag `v0.1.0` created

**Key beat:** "36 work items created in under 2 minutes—no copy-paste, no manual entry"

---

### Act 2: The DBA (Minutes 20–32)

> "Now let's switch to our DBA hat. We need database tables before we can write any API code."

**[Minute 20]** Open Copilot Chat

* Type: `Create Flyway migrations for program_type, program, and notification tables following sql.instructions.md`
* **Expected output:** 4 migration files generated

**[Minute 24]** Review generated migrations

* `V001__create_program_types_table.sql`
* `V002__create_programs_table.sql`
* `V003__create_notifications_table.sql`
* `V004__seed_program_types.sql`

**[Minute 26]** Verify SQL conventions

* Show `IF NOT EXISTS` guards
* Show `NVARCHAR` for Unicode support (EN/FR)
* Show `INSERT ... WHERE NOT EXISTS` for seed data (not MERGE)
* **Expected output:** Clean, idiomatic SQL following conventions

**[Minute 28]** Start backend to apply migrations

* Run `.\scripts\Start-Local.ps1 -BackendOnly -SkipBuild`
* Watch Flyway apply migrations
* **Expected output:** "Successfully applied 4 migrations"

**[Minute 30]** Verify database

* Open H2 Console at `http://localhost:8080/h2-console`
* Query: `SELECT * FROM program_type`
* **Expected output:** 5 program types with EN/FR names

**[Minute 32]** Checkpoint

* `git add . && git commit -m "AB#2 Add database migrations"`
* `git tag v0.2.0`
* **Expected output:** Tag `v0.2.0` created

**Key beat:** "Flyway migrations with proper guards—AI understood our SQL conventions"

---

### Act 3: The Backend Developer (Minutes 32–52)

> "Database is ready. Time for some Java. Let's build our REST API."

**[Minute 32]** Generate Spring Boot scaffolding

* Type: `Create Spring Boot project structure with Program entity, repository, service, and controller following java.instructions.md`
* **Expected output:** Package structure under `com.ontario.program`

**[Minute 36]** Review generated code

* Show constructor injection (no `@Autowired` on fields)
* Show `@Valid` on controller parameters
* Show `ProblemDetail` for RFC 7807 errors
* Show Java records for DTOs
* **Expected output:** Clean code following conventions

**[Minute 40]** Generate remaining endpoints

* Type: `Add POST /api/programs, GET /api/programs, GET /api/programs/{id}, PUT /api/programs/{id}/review, GET /api/program-types endpoints`
* **Expected output:** All 5 endpoints generated

**[Minute 45]** Test with curl

```bash
# Test program types
curl http://localhost:8080/api/program-types

# Submit a program
curl -X POST http://localhost:8080/api/programs \
  -H "Content-Type: application/json" \
  -d '{"programName":"Youth Employment","programDescription":"Help youth find jobs","programTypeId":1}'

# List programs
curl http://localhost:8080/api/programs
```

* **Expected output:** 201 Created, program listed with SUBMITTED status

**[Minute 50]** Show validation error

```bash
curl -X POST http://localhost:8080/api/programs \
  -H "Content-Type: application/json" \
  -d '{}'
```

* **Expected output:** 400 Bad Request with ProblemDetail JSON

**[Minute 52]** Checkpoint

* `git add . && git commit -m "AB#3 Add backend API endpoints"`
* `git tag v0.3.0`
* **Expected output:** Tag `v0.3.0` created

**Key beat:** "5 API endpoints with validation, error handling, and RFC 7807—all following our conventions"

---

### Act 4: The Frontend Developer (Minutes 52–70)

> "API is running. Let's build the citizen-facing portal—bilingual, accessible, Ontario Design System."

**[Minute 52]** Generate React project

* Type: `Create React frontend with Vite, TypeScript, and i18next following react.instructions.md`
* **Expected output:** Vite project with i18n configuration

**[Minute 56]** Generate layout components

* Type: `Create Layout, Header with LanguageToggle, and Footer components using Ontario Design System CSS classes`
* **Expected output:** Components using `ontario-header`, `ontario-footer` classes

**[Minute 60]** Generate program submission form

* Type: `Create SubmitProgram page with form validation and bilingual labels`
* **Expected output:** Form with Ontario DS classes, EN/FR labels

**[Minute 64]** Start frontend

* Run `.\scripts\Start-Local.ps1 -FrontendOnly`
* Open `http://localhost:3000`
* **Expected output:** Ontario-styled header visible

**[Minute 66]** Live demo

* Toggle language EN ↔ FR
* Fill out submission form
* Submit program
* Show confirmation page
* **Expected output:** Program submitted, confirmation displayed in selected language

**[Minute 68]** Show accessibility

* Tab through form elements
* Show focus indicators
* Show `<html lang="fr">` after language toggle
* **Expected output:** Keyboard navigation works, lang attribute updates

**[Minute 70]** Checkpoint

* `git add . && git commit -m "AB#4 Add citizen portal frontend"`
* `git tag v0.4.0`
* **Expected output:** Tag `v0.4.0` created

> "We have a working citizen portal. Users can submit programs in English or French. But look at the ADO board..."

**Key beat (Cliffhanger):** Show ADO board—Ministry Portal stories still in "New"

**Audience engagement point:** "What happens when a citizen submits a program? Who reviews it?"

---

## Part 2: Closing the Loop (Minutes 70–130)

### Recap (Minutes 70–73)

> "Let's recap where we are. We have infrastructure in Azure, 36 ADO work items, 4 database tables, 5 API endpoints, and a bilingual citizen portal. But the loop isn't closed—submitted programs go nowhere."

**[Minute 71]** Show database

* Query: `SELECT id, program_name, status FROM program`
* **Expected output:** Programs with status `SUBMITTED`

**[Minute 73]** Show ADO board

* Point out Ministry Portal feature with 3 stories in "New"
* **Expected output:** Visual confirmation of incomplete work

---

### Act 5: Completing the Story (Minutes 73–87)

> "Let's give the Ministry their dashboard."

**[Minute 73]** Generate review dashboard

* Type: `Create ReviewDashboard page showing all SUBMITTED programs with Ontario table styling`
* **Expected output:** Table component with `ontario-table` class

**[Minute 77]** Generate review detail page

* Type: `Create ReviewDetail page at /review/:id with approve/reject buttons`
* **Expected output:** Detail view with action buttons

**[Minute 81]** Wire up API calls

* Type: `Connect ReviewDashboard to GET /api/programs?status=SUBMITTED and ReviewDetail to PUT /api/programs/{id}/review`
* **Expected output:** Pages fetching data from API

**[Minute 84]** Live demo

* Navigate to `/review`
* Click a program to view details
* Approve the program
* Show status change in database
* **Expected output:** Program status changes to `APPROVED`

**[Minute 87]** Checkpoint

* `git add . && git commit -m "AB#5 Add ministry review portal"`
* `git tag v0.5.0`
* **Expected output:** Tag `v0.5.0` created

**Key beat:** "The loop is closed. Citizens submit, Ministry reviews, everyone speaks both languages."

---

### Act 6: The QA Engineer (Minutes 87–100)

> "Working code is great. Tested code is better. Let's add some quality assurance."

**[Minute 87]** Generate backend tests

* Type: `Create controller tests for ProgramController using MockMvc`
* **Expected output:** Test class with @WebMvcTest

**[Minute 91]** Generate frontend tests

* Type: `Create React component tests for SubmitProgram using Vitest and Testing Library`
* **Expected output:** Test file with render and user event assertions

**[Minute 95]** Run tests

```bash
# Backend
cd backend && ./mvnw test

# Frontend
cd frontend && npm test
```

* **Expected output:** All tests passing

**[Minute 98]** Verify accessibility

* Run axe-core audit in browser
* **Expected output:** No critical accessibility violations

**[Minute 100]** Checkpoint

* `git add . && git commit -m "AB#6 Add unit and accessibility tests"`
* `git tag v0.6.0`
* **Expected output:** Tag `v0.6.0` created

---

### Act 7: The DevOps Engineer (Minutes 100–107)

> "Tests pass locally. Let's make sure they pass on every commit."

**[Minute 100]** Generate CI workflow

* Type: `Create GitHub Actions CI workflow that builds and tests both backend and frontend`
* **Expected output:** `.github/workflows/ci.yml`

**[Minute 103]** Configure Dependabot

* Type: `Create Dependabot config for Maven and npm dependencies`
* **Expected output:** `.github/dependabot.yml`

**[Minute 105]** Enable security

* Show GitHub Advanced Security settings
* Enable secret scanning
* **Expected output:** Security features enabled

**[Minute 107]** Checkpoint

* `git add . && git commit -m "AB#7 Add CI/CD and security configuration"`
* `git tag v0.7.0`
* **Expected output:** Tag `v0.7.0` created

---

### Act 8: The Full Stack Change (Minutes 107–120)

> "Final challenge. Product owner wants a new field: program budget. Let's add it end-to-end."

**[Minute 107]** Add migration

* Type: `Create Flyway migration to add program_budget DECIMAL(15,2) column to program table`
* **Expected output:** `V005__add_program_budget_column.sql`

**[Minute 110]** Update entity and DTO

* Type: `Add programBudget field to Program entity and ProgramSubmitRequest with @DecimalMin(0) validation`
* **Expected output:** Field added to Java records

**[Minute 113]** Update API

* Type: `Update POST /api/programs to accept and persist programBudget`
* **Expected output:** Controller and service updated

**[Minute 116]** Update frontend

* Type: `Add budget input field to SubmitProgram form with currency formatting`
* **Expected output:** Form field with Ontario DS styling

**[Minute 118]** Update tests

* Type: `Update tests to include programBudget field`
* **Expected output:** Tests passing with new field

**[Minute 120]** Checkpoint

* `git add . && git commit -m "AB#8 Add program budget field end-to-end"`
* `git tag v0.8.0`
* **Expected output:** Tag `v0.8.0` created

**Key beat:** "Full stack change in 13 minutes—migration, entity, DTO, API, form, tests"

---

### Closing (Minutes 120–130)

> "Let's see where we've been."

**[Minute 120]** Show final ADO board

* All stories Done or Closed
* **Expected output:** Clean board with completed work

**[Minute 122]** Show git log

* `git log --oneline`
* **Expected output:** ~20 commits, all linked with `AB#` numbers

**[Minute 124]** Show final stats

* Recap key numbers (see table below)
* **Expected output:** Impressive metrics visible

**[Minute 126]** Final checkpoint

* `git tag v1.0.0`
* **Expected output:** Final release tag created

**[Minute 128]** Q&A

> "Questions? We have a few minutes."

---

## Recovery Decision Matrix

| Situation | Time Lost | Action |
|-----------|-----------|--------|
| Copilot generates wrong code | < 2 min | Fix manually, continue |
| Copilot generates wrong code | 2–5 min | Retry prompt once, then fast-forward |
| Build/compile error | > 2 min | Fast-forward to checkpoint tag |
| Azure connectivity lost | Any | Switch to H2 local (`-UseAzureSql` → remove flag) |
| Total overrun > 10 min | — | Skip Act 6 (QA) or Act 7 (DevOps) |

---

## Tagged Checkpoints

| Tag | Checkpoint | Contents | Minute |
|-----|------------|----------|--------|
| `v0.1.0` | Scaffolding Complete | 13 scaffolding files, 36 ADO work items | ~20 |
| `v0.2.0` | Database Ready | 4 Flyway migrations applied | ~32 |
| `v0.3.0` | API Running | Spring Boot + 5 endpoints + curl tests passing | ~52 |
| `v0.4.0` | Citizen Portal Live | React + Ontario DS + bilingual form submission | ~70 |
| `v0.5.0` | Ministry Portal Complete | Review dashboard + detail + approve/reject | ~87 |
| `v0.6.0` | Tests Passing | Backend + frontend + accessibility tests | ~100 |
| `v0.7.0` | CI/CD Ready | GitHub Actions, Dependabot, secret scanning | ~107 |
| `v0.8.0` | Budget Field Added | `program_budget` end-to-end | ~120 |
| `v1.0.0` | Demo Complete | All features, tests, CI complete | ~130 |

---

## Key Numbers Summary

| Metric | Count |
|--------|-------|
| Total demo duration | 130 minutes |
| Lines of Java code | ~500 |
| Lines of TypeScript/React code | ~800 |
| Lines of SQL | ~100 |
| API endpoints | 5 |
| Database tables | 3 |
| Flyway migrations | 4 (+1 for budget) |
| React pages/components | ~10 |
| ADO work items created | 36 |
| Git commits | ~20 |
| Tagged checkpoints | 9 |
| Languages supported | 2 (EN/FR) |
| CI workflows | 1 |
| Security tools | 3 (Dependabot, Secret Scanning, GHAS) |
