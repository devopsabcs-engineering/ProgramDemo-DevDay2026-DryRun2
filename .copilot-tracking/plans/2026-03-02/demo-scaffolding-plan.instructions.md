---
applyTo: '.copilot-tracking/changes/2026-03-02/demo-scaffolding-changes.md'
---
<!-- markdownlint-disable-file -->
# Implementation Plan: Demo Scaffolding

## Overview

Scaffold all 13 foundational files (7 configuration + 3 documentation + 2 scripts + TALK-TRACK.md) for the OPS Program Approval demo application, plus create 36 ADO work items via MCP, establishing the complete project foundation before any application code is written.

## Objectives

### User Requirements

* Create 7 configuration files (`.gitignore`, `.vscode/mcp.json`, `.github/copilot-instructions.md`, 4 instruction files) — Source: demo-scaffolding.prompt.md
* Create 3 documentation files (`docs/architecture.md`, `docs/data-dictionary.md`, `docs/design-document.md`) — Source: demo-scaffolding.prompt.md
* Create 2 PowerShell scripts (`scripts/Start-Local.ps1`, `scripts/Stop-Local.ps1`) — Source: demo-scaffolding.prompt.md
* Create `TALK-TRACK.md` at repository root with 130-minute minute-by-minute demo script — Source: demo-scaffolding.prompt.md
* Create 36 ADO work items (1 Epic + 8 Features + 27 Stories) via MCP during implementation — Source: demo-scaffolding.prompt.md, research §4

### Derived Objectives

* Ensure all instruction files follow Copilot instructions format with correct `applyTo` frontmatter — Derived from: consistency with GitHub Copilot instructions specification
* Maintain cross-references between documentation files (architecture references data dictionary, design document references both) — Derived from: documentation coherence for demo audience
* Validate Mermaid diagrams render correctly in architecture and data dictionary files — Derived from: demo reliability requirement
* Structure talk track with recovery strategies and checkpoints — Derived from: research §3.1 recovery decision matrix

## Context Summary

### Project Files

* [README.md](../../README.md) - Business context, tech stack, demo flow, application screens, lessons learned (180 lines)
* [.github/prompts/demo-scaffolding.prompt.md](../../.github/prompts/demo-scaffolding.prompt.md) - Full scaffolding specification with all 13 files (262 lines)

### References

* [demo-scaffolding-research.md](../../.copilot-tracking/research/2026-03-02/demo-scaffolding-research.md) - Primary research (948 lines)
* [configuration-layer-research.md](../../.copilot-tracking/research/subagents/2026-03-02/configuration-layer-research.md) - Configuration files deep dive (1005 lines)
* [documentation-layer-research.md](../../.copilot-tracking/research/subagents/2026-03-02/documentation-layer-research.md) - Documentation files deep dive (1076 lines)
* [operational-layer-research.md](../../.copilot-tracking/research/subagents/2026-03-02/operational-layer-research.md) - Operational files deep dive (1137 lines)

### Standards References

* Ontario Design System — CSS classes from `@ongov/ontario-design-system-global-styles`
* WCAG 2.2 Level AA — Accessibility requirements for government web applications
* RFC 7807 — Problem Details for HTTP APIs (error response format)
* Flyway — Database migration naming and versioning conventions

## Implementation Checklist

<!-- NOTE: Phases 1–4 are all parallelizable with each other (no shared files or dependencies). They can execute concurrently as a single parallel batch. Phases 5–7 are sequential due to content/MCP dependencies. -->

### [ ] Implementation Phase 1: Configuration Layer — Core Files

<!-- parallelizable: true -->

* [ ] Step 1.1: Create `.gitignore` with Java + Node + IDE + OS rules
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 12-85)
* [ ] Step 1.2: Create `.vscode/mcp.json` with ADO MCP server configuration
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 87-120)
* [ ] Step 1.3: Create `.github/copilot-instructions.md` with global project context
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 122-189)

### [ ] Implementation Phase 2: Configuration Layer — Instruction Files

<!-- parallelizable: true -->

* [ ] Step 2.1: Create `.github/instructions/ado-workflow.instructions.md`
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 191-231)
* [ ] Step 2.2: Create `.github/instructions/java.instructions.md`
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 233-316)
* [ ] Step 2.3: Create `.github/instructions/react.instructions.md`
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 318-379)
* [ ] Step 2.4: Create `.github/instructions/sql.instructions.md`
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 381-435)

### [ ] Implementation Phase 3: Documentation Layer

<!-- parallelizable: true -->

* [ ] Step 3.1: Create `docs/architecture.md` with Mermaid flowchart and Azure resource table
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 437-498)
* [ ] Step 3.2: Create `docs/data-dictionary.md` with Mermaid ER diagram and column specifications
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 500-591)
* [ ] Step 3.3: Create `docs/design-document.md` with API endpoints, DTOs, and component hierarchy
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 593-668)

### [ ] Implementation Phase 4: Operational Layer — Scripts

<!-- parallelizable: true -->

* [ ] Step 4.1: Create `scripts/Start-Local.ps1` with parameter switches and prerequisite checks
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 670-719)
* [ ] Step 4.2: Create `scripts/Stop-Local.ps1` with port-based process termination
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 721-779)

### [ ] Implementation Phase 5: Talk Track

<!-- parallelizable: false -->

* [ ] Step 5.1: Create `TALK-TRACK.md` Part 1 — "Building From Zero" (Minutes 0–70)
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 781-837)
* [ ] Step 5.2: Create `TALK-TRACK.md` Part 2 — "Closing the Loop" (Minutes 70–130)
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 839-877)
* [ ] Step 5.3: Add recovery matrix, checkpoints, and key numbers summary
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 879-912)

### [ ] Implementation Phase 6: ADO Work Items via MCP

<!-- parallelizable: false -->

* [ ] Step 6.1: Create Epic "OPS Program Approval System"
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 914-938)
* [ ] Step 6.2: Create 8 Features under the Epic
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 940-965)
* [ ] Step 6.3: Create 27 Stories under their respective Features
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 967-1022)
* [ ] Step 6.4: Close Infrastructure Setup Feature (pre-deployed in `rg-dev-125`)
  * Details: .copilot-tracking/details/2026-03-02/demo-scaffolding-details.md (Lines 1024-1044)

### [ ] Implementation Phase 7: Validation

<!-- parallelizable: false -->

* [ ] Step 7.1: Verify all 13 files exist with correct content
  * Confirm file paths, frontmatter, and content structure for each file
  * Validate Mermaid diagrams render (architecture flowchart, ER diagram)
* [ ] Step 7.2: Validate ADO work items created correctly
  * Verify 36 work items exist (1 Epic + 8 Features + 27 Stories)
  * Verify parent-child relationships are correct
  * Verify Infrastructure Setup Feature is Closed
* [ ] Step 7.3: Cross-reference validation
  * Verify instruction file `applyTo` globs match intended directories
  * Verify documentation cross-references between architecture, data dictionary, and design document
  * Verify talk track checkpoints align with implementation phases
* [ ] Step 7.4: Fix minor validation issues
  * Iterate on any formatting, content, or cross-reference errors
  * Apply fixes directly when corrections are straightforward
* [ ] Step 7.5: Report blocking issues
  * Document issues requiring additional research
  * Provide next steps and recommended planning for large-scale fixes

## Planning Log

See [demo-scaffolding-log.md](../logs/2026-03-02/demo-scaffolding-log.md) for discrepancy tracking, implementation paths considered, and suggested follow-on work.

## Dependencies

* Node.js 20+ — required for `npx` in MCP configuration
* Azure DevOps MCP server (`azure-devops-mcp` npm package) — required for ADO work item creation in Phase 6
* Azure DevOps organization `MngEnvMCAP675646` with project `ProgramDemo-DevDay2026-DryRun2` — must be accessible
* Git — repository must be initialized with `README.md` already committed

## Success Criteria

* All 13 scaffolding files exist at correct paths with complete content — Traces to: demo-scaffolding.prompt.md success criteria
* 36 ADO work items created with correct hierarchy (1 Epic → 8 Features → 27 Stories) — Traces to: research §4 ADO Work Item Creation Plan
* All instruction files have valid `applyTo` frontmatter targeting correct directories — Traces to: research §1.3–1.7
* Mermaid diagrams in `docs/architecture.md` and `docs/data-dictionary.md` render correctly — Traces to: research §2.1, §2.2
* Talk track covers all 130 minutes with checkpoints, recovery strategies, and presenter dialogue — Traces to: research §3.1
* PowerShell scripts include comment-based help, prerequisite checks, and parameter validation — Traces to: research §3.2, §3.3
* Infrastructure Setup Feature is Closed; all other work items are in New state — Traces to: research §4 State Transitions
