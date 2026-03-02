<!-- markdownlint-disable-file -->
# Planning Log: Demo Scaffolding

## Discrepancy Log

Gaps and differences identified between research findings and the implementation plan.

### Unaddressed Research Items

* DR-01: Official MCP package `@azure-devops/mcp` v2.4.0 provides full CRUD, browser-based auth, and 9 selectable domains
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 97-105)
  * Reason: Prompt explicitly specifies `azure-devops-mcp` (community package) with exact command/args — prompt is single source of truth
  * Impact: Low — community package is functional for demo needs; official package is documented as future alternative

* DR-02: Azure DevOps MCP authentication flow (PAT vs. OAuth) verification needed on demo machine
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 925-926)
  * Reason: Pre-demo preparation is out of scope for scaffolding implementation
  * Impact: Medium — authentication failure during live demo would require fallback; should be verified in dry run

* DR-03: Exact Copilot prompts for reliable MCP work item batching not researched
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 927-928)
  * Reason: Prompt engineering for MCP batching is runtime optimization, not scaffolding file content
  * Impact: Medium — affects Act 1 timing (12 min for 36 items); recovery plan covers this via fast-forward strategy

* DR-04: Ontario Design System npm version and Vite integration confirmation
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 930-931)
  * Reason: Version pinning happens during React project scaffolding (Act 4), not during instruction file creation
  * Impact: Low — CSS import path is documented in react.instructions.md; version resolved at install time

* DR-05: `.devcontainer/devcontainer.json` for Java 21 + Node 20
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 932-933)
  * Reason: Explicitly out of scope per demo-scaffolding.prompt.md
  * Impact: Low — README.md mentions it as a lesson learned; not needed for demo execution

* DR-06: GitHub Actions CI workflow for dual-stack builds
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 934-935)
  * Reason: CI workflow is built live during Act 7 (minutes 100–107), not scaffolded
  * Impact: Low — covered by talk track but not a scaffolding file

### Plan Deviations from Research

* DD-01: Architecture diagram uses `flowchart LR` instead of C4
  * Research recommends: `flowchart LR` with `subgraph` (universal rendering, simpler syntax)
  * Plan implements: `flowchart LR` with `subgraph` as recommended
  * Rationale: Research and plan are aligned — C4 was considered and rejected for demo reliability. The prompt mentions "C4/flowchart" but research determined flowchart is the better choice.

* DD-02: Talk track implemented as single file rather than modular sections
  * Research recommends: Single `TALK-TRACK.md` file at repository root
  * Plan implements: Single file with Part 1 and Part 2 sections, plus supporting appendices
  * Rationale: Research and plan are aligned — single file is easier for presenter to navigate during live demo

## Implementation Paths Considered

### Selected: File-by-File Implementation in Parallel Phases

* Approach: Create files grouped by layer (configuration, documentation, operational) with parallelizable phases. ADO work items created sequentially via MCP after all files exist. Talk track as standalone sequential phase.
* Rationale: Phases 1–4 have no file dependencies between them and can execute in parallel. Phase 5 (talk track) references all other files so runs after. Phase 6 (ADO) requires MCP and must be sequential. This maximizes throughput while respecting dependencies.
* Evidence: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) — all 13 files are independent; only the talk track references other files conceptually.

### IP-01: Single Sequential Phase for All Files

* Approach: Create all 13 files one at a time in dependency order
* Trade-offs: Simpler to track but significantly slower; no parallelism benefit. Files have no real dependencies on each other.
* Rejection rationale: Unnecessary serialization — all configuration, documentation, and script files are independent.

### IP-02: Layer-First with Immediate ADO Creation

* Approach: Create ADO work items first (Phase 1), then use work item IDs in file content
* Trade-offs: Enables embedding real ADO IDs in documentation. However, no file content actually needs work item IDs — they reference patterns (`AB#{id}`) not specific item numbers.
* Rejection rationale: ADO work items don't influence file content; creating them first adds unnecessary blocking dependency.

### IP-03: Official MCP Package (`@azure-devops/mcp`)

* Approach: Use Microsoft's official `@azure-devops/mcp` v2.4.0 instead of community `azure-devops-mcp`
* Trade-offs: Browser-based auth (no PAT), 9 domains, full CRUD capabilities. But diverges from prompt specification.
* Rejection rationale: Prompt is single source of truth — specifies exact command and args for community package. Official package documented as future alternative.

## Suggested Follow-On Work

Items identified during planning that fall outside current scope.

* WI-01: Pre-demo preparation automation script — Verify all prerequisites (Java 21, Node 20, MCP auth, ADO access) before going live (High)
  * Source: [demo-scaffolding-research.md](../../research/2026-03-02/demo-scaffolding-research.md) (Lines 929-930)
  * Dependency: Scaffolding complete (all 13 files created)

* WI-02: MCP authentication verification on demo machine — Test `azure-devops-mcp` auth flow and verify PAT or OAuth works (High)
  * Source: DR-02
  * Dependency: `.vscode/mcp.json` created (Step 1.2)

* WI-03: Copilot prompt library for MCP work item batching — Develop and test specific prompts for reliable batch creation of ADO work items within timing constraints (Medium)
  * Source: DR-03
  * Dependency: MCP auth verified (WI-02)

* WI-04: `.devcontainer/devcontainer.json` creation — Java 21 + Node 20 dev container for consistent environments (Low)
  * Source: DR-05, README.md lessons learned
  * Dependency: None

* WI-05: Evaluate migration to official `@azure-devops/mcp` package — Compare capabilities, auth flow, and reliability vs. community package for future dry runs (Low)
  * Source: DR-01, IP-03
  * Dependency: Demo complete; evaluation is post-demo activity

* WI-06: Ontario Design System npm version pinning — Confirm `@ongov/ontario-design-system-global-styles` version and Vite CSS import path (Medium)
  * Source: DR-04
  * Dependency: React project scaffolding (Act 4 of talk track)

## Validation Log

### Validation Run 1 — 2026-03-02

**Status:** PASS WITH WARNINGS

**Findings:**

| ID | Severity | Description | Resolution |
|----|----------|-------------|------------|
| V-01 | Major | All 19 line number references in plan pointed to incorrect lines in details file | Fixed — updated all line references to match actual heading positions |
| V-02 | Minor | Documentation steps don't explicitly instruct cross-referencing between docs files | Accepted — Phase 7 validation catches cross-reference issues; minimal rework risk |
| V-03 | Minor | Phases 1–4 inter-phase parallelism not explicitly annotated | Fixed — added top-level comment noting Phases 1–4 can execute as parallel batch |
| V-04 | Info | Research line references in details file are plausible but unverified | Accepted — full content is inline; line refs are navigational aids only |
| V-05 | Info | All 14 Key Discoveries, 6 research topics, 3 scenarios accounted for | No action needed |
| V-06 | Info | All parallelization markers valid with no dependency conflicts | No action needed |
| V-07 | Info | ADO work item counts verified: 1 + 8 + 27 = 36 | No action needed |

**Post-fix status:** PASS — no critical or major findings remain.

## Validation Log

Validation performed: 2026-03-02 | Status: **PASS WITH WARNINGS**

### Completeness Check

| Check | Result | Notes |
|-------|--------|-------|
| All 13 files covered | PASS | Steps 1.1–1.3, 2.1–2.4, 3.1–3.3, 4.1–4.2, 5.1–5.3 map to all 13 files |
| All 36 ADO work items covered | PASS | Step 6.1 (1 Epic) + 6.2 (8 Features) + 6.3 (27 Stories) = 36. Story count: 4+5+6+3+4+3+2 = 27 |
| All research sections mapped | PASS | §1.1–1.7, §2.1–2.3, §3.1–3.3, §4 all mapped to plan steps. Key Discoveries, Technical Scenarios, and Potential Next Research mapped to DR/DD/WI items |
| Success criteria for every step | PASS | Every step in the details file has a "Success criteria:" section with measurable criteria |

### Research Alignment Check

| Check | Result | Notes |
|-------|--------|-------|
| Plan steps reference correct research sections | PASS | Each step references the correct research section by number (§1.1–§4) |
| All 14 Key Discoveries reflected | PASS | All incorporated into relevant step content or documented as DR items |
| All 6 Potential Next Research topics tracked | PASS | Mapped to DR-01 through DR-06 and WI-01 through WI-06 |
| All 3 Technical Scenarios reflected | PASS | MCP Package → DR-01/IP-03; Architecture Diagram → DD-01; Script Process Management → Steps 4.1/4.2 |
| Technical details consistent | PASS | File paths, frontmatter `applyTo` globs, content tables, code blocks, and Mermaid syntax consistent between research and plan |

### Internal Consistency Check

| Check | Result | Notes |
|-------|--------|-------|
| Plan → Details line references | **FAIL** | All 19 line references are incorrect — see V-01 below |
| Cross-references between files | PASS | Plan references details, research, and log files with correct relative paths |
| Parallelization markers | PASS | No dependency conflicts. Phases 1–4 `parallelizable: true` (all steps independent within phase). Phases 5–7 `parallelizable: false` (sequential dependencies correct) |
| Phase dependency order | PASS | Phase 6 depends on Phase 1 (MCP config). Phase 7 depends on all. Phases 1–4 independent |

### Implementation Readiness Check

| Check | Result | Notes |
|-------|--------|-------|
| Every step actionable | PASS | Full content specification, code blocks, tables, and structure provided for every step |
| Dependencies listed | PASS | Each step has a "Dependencies:" section (most are "None — independent file") |
| Validation steps included | PASS | Phase 7 covers file verification (7.1), ADO verification (7.2), cross-reference validation (7.3), fix (7.4), and blocking issue reporting (7.5) |
| Final validation comprehensive | PASS | Step 7.3 checks `applyTo` globs, doc cross-references, talk track alignment, and commit format consistency |

### Findings

#### Major

* **V-01: All 19 plan-to-details line number references are incorrect**
  * Severity: Major
  * Location: Plan checklist, "Details:" lines for every step
  * Description: The plan references line ranges in the details file that do not match actual content. Every reference points to a line range that is systematically lower than the actual step location, with the offset growing from ~47 lines (Step 1.1) to ~180 lines (Step 3.1) before decreasing again. An implementer following line numbers would navigate to incorrect content.
  * Correct line references (heading line to line before next heading):

    | Step | Plan Claims | Actual Lines |
    |------|------------|-------------|
    | 1.1 | 14-39 | 12-86 |
    | 1.2 | 41-60 | 87-121 |
    | 1.3 | 62-97 | 122-186 |
    | 2.1 | 99-127 | 191-232 |
    | 2.2 | 129-175 | 233-317 |
    | 2.3 | 177-228 | 318-380 |
    | 2.4 | 230-265 | 381-432 |
    | 3.1 | 267-322 | 437-499 |
    | 3.2 | 324-411 | 500-592 |
    | 3.3 | 413-510 | 593-665 |
    | 4.1 | 512-567 | 670-720 |
    | 4.2 | 569-606 | 721-776 |
    | 5.1 | 608-680 | 781-838 |
    | 5.2 | 682-745 | 839-878 |
    | 5.3 | 747-800 | 879-909 |
    | 6.1 | 802-815 | 914-939 |
    | 6.2 | 817-850 | 940-966 |
    | 6.3 | 852-920 | 967-1023 |
    | 6.4 | 922-930 | 1024-1041 |

  * Impact: Medium — steps are still identifiable by heading name (`### Step X.Y`), so implementation is not blocked. However, any agent or human following line numbers directly would read wrong content.
  * Recommendation: Update all 19 line references in the plan to match actual details file content.

#### Minor

* **V-02: Documentation steps do not instruct cross-referencing between files**
  * Severity: Minor
  * Location: Details Steps 3.1, 3.2, 3.3
  * Description: The plan's derived objectives require "cross-references between documentation files (architecture references data dictionary, design document references both)." However, the individual step instructions for the three documentation files do not mention adding cross-references to each other. Each step lists dependencies as "None — independent file." The cross-referencing requirement is only verified retroactively in Phase 7 validation (Step 7.3), risking rework if the implementer creates docs without cross-references.
  * Impact: Low — validation phase will catch it, but adding a note to each doc step would prevent rework.
  * Recommendation: Add a note to Steps 3.1, 3.2, and 3.3 instructing the implementer to include cross-references to the other two documentation files.

* **V-03: Phases 1–4 could execute in inter-phase parallel, not just intra-phase**
  * Severity: Minor
  * Location: Plan checklist structure
  * Description: The plan structures Phases 1–4 as sequential phases with intra-phase parallelism. The log notes "all 13 files are independent" and rejects IP-01 for "unnecessary serialization," yet the plan still presents Phases 1→2→3→4 sequentially. All 13 files across Phases 1–4 have zero inter-dependencies and could execute simultaneously.
  * Impact: Low — affects throughput optimization only. The plan is not incorrect, just suboptimal.
  * Recommendation: Add a note to the plan indicating Phases 1–4 can execute in any order or in parallel.

#### Info

* **V-04: Research line references in details file are plausible but not precisely verified**
  * Severity: Info
  * Location: Details file "Context references" sections within each step
  * Description: Each step in the details file references specific line ranges in the research file (e.g., "Lines 54-95"). These are plausible given the research file structure, but precise verification was not performed for all 19 references. Since the details file contains the full content specification for each step (not just a pointer), this has no practical impact on implementation.

* **V-05: All 14 Key Discoveries from research are accounted for**
  * Severity: Info
  * Description: Every discovery from research §5 is either incorporated directly into the relevant step's content specification or tracked as a DR/DD item in this log. No research findings were dropped or overlooked.

* **V-06: All parallelization markers are valid with no dependency conflicts**
  * Severity: Info
  * Description: Phases 1–4 marked `parallelizable: true` — all steps within each phase are independent. Phases 5–7 marked `parallelizable: false` — Phase 5 steps build a single file sequentially, Phase 6 steps have parent-child ID dependencies, Phase 7 is sequential validation. No conflicts detected.

* **V-07: ADO work item counts verified: 1 Epic + 8 Features + 27 Stories = 36 total**
  * Severity: Info
  * Description: Story distribution across features verified: Database Layer (4) + Backend API (5) + Citizen Portal (6) + Ministry Portal (3) + Quality Assurance (4) + CI/CD Pipeline (3) + Live Change Demo (2) = 27. Infrastructure Setup has 0 stories (pre-deployed, closed in Step 6.4).
