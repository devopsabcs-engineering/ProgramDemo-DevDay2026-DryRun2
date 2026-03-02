<!-- markdownlint-disable-file -->
# Release Changes: Demo Scaffolding

**Related Plan**: demo-scaffolding-plan.instructions.md
**Implementation Date**: 2026-03-02

## Summary

Scaffold all 13 foundational files (7 configuration + 3 documentation + 2 scripts + TALK-TRACK.md) for the OPS Program Approval demo application, plus create 36 ADO work items via MCP.

## Changes

### Added

* `.gitignore` - Git ignore file for Java/Node.js project
* `.vscode/mcp.json` - MCP configuration for Azure DevOps
* `.github/copilot-instructions.md` - GitHub Copilot project instructions
* `.github/instructions/ado-workflow.instructions.md` - ADO workflow conventions
* `.github/instructions/java.instructions.md` - Java 21/Spring Boot conventions
* `.github/instructions/react.instructions.md` - React 18/TypeScript/Vite conventions
* `.github/instructions/sql.instructions.md` - Azure SQL/Flyway conventions
* `docs/architecture.md` - System architecture documentation
* `docs/data-dictionary.md` - Database schema documentation
* `docs/design-document.md` - Technical design specification
* `scripts/Start-Local.ps1` - Local development startup script
* `scripts/Stop-Local.ps1` - Local development shutdown script
* `TALK-TRACK.md` - Demo talk track with timing and audience engagement

### ADO Work Items Created (via MCP)

**Epic (1):**
* ID 1880: OPS Program Approval System (State: New)

**Features (8):**
* ID 1881: Infrastructure Setup (State: Closed) - Pre-deployed in rg-dev-125
* ID 1882: Database Layer (State: New)
* ID 1883: Backend API (State: New)
* ID 1884: Citizen Portal (State: New)
* ID 1885: Ministry Portal (State: New)
* ID 1886: Quality Assurance (State: New)
* ID 1887: CI/CD Pipeline (State: New)
* ID 1888: Live Change Demo (State: New)

**User Stories (27):**

Database Layer (Parent: 1882):
* ID 1889: Create program_type table
* ID 1890: Create program table
* ID 1891: Create notification table
* ID 1892: Insert seed data

Citizen Portal (Parent: 1884):
* ID 1893: React project scaffolding with Vite
* ID 1894: Ontario DS layout
* ID 1895: Program submission form
* ID 1896: Submission confirmation page
* ID 1897: Program search page
* ID 1898: Bilingual EN/FR support with i18next

Backend API (Parent: 1883):
* ID 1899: Spring Boot project scaffolding
* ID 1900: Submit program endpoint
* ID 1901: List and get program endpoints
* ID 1902: Review program endpoint
* ID 1903: Program types endpoint

Live Change Demo (Parent: 1888):
* ID 1904: Add program_budget field end-to-end
* ID 1905: Update tests for new field

Quality Assurance (Parent: 1886):
* ID 1906: Backend controller tests
* ID 1907: Frontend component tests
* ID 1908: Accessibility tests
* ID 1909: Bilingual verification

Ministry Portal (Parent: 1885):
* ID 1910: Review dashboard page
* ID 1911: Review detail page
* ID 1912: Approve/reject actions

CI/CD Pipeline (Parent: 1887):
* ID 1913: CI workflow
* ID 1914: Dependabot config
* ID 1915: Secret scanning

### Modified

### Removed

## Database Layer Implementation (Feature #1882)

### Added

* `database/migrations/V001__create_program_type_table.sql` - AB#1889 Create program_type lookup table with bilingual names
* `database/migrations/V002__create_program_table.sql` - AB#1890 Create program table with FK to program_type
* `database/migrations/V003__create_notification_table.sql` - AB#1891 Create notification table with FK to program
* `database/migrations/V004__seed_program_types.sql` - AB#1892 Insert 5 bilingual seed categories

## Additional or Deviating Changes

* Infrastructure Setup Feature (ID 1881) closed immediately as infrastructure is pre-deployed in rg-dev-125

## Release Summary

**Total Files Created:** 13
* Configuration: 7 files (.gitignore, mcp.json, copilot-instructions.md, 4 instruction files)
* Documentation: 3 files (architecture.md, data-dictionary.md, design-document.md)
* Scripts: 2 files (Start-Local.ps1, Stop-Local.ps1)
* Talk Track: 1 file (TALK-TRACK.md)

**Total ADO Work Items Created:** 36
* 1 Epic (ID 1880)
* 8 Features (IDs 1881-1888), 1 closed
* 27 User Stories (IDs 1889-1915)

**Azure DevOps Project:** ProgramDemo-DevDay2026-DryRun2
**Organization:** MngEnvMCAP675646

