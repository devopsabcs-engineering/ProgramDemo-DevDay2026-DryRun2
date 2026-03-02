---
title: "Configuration Layer Research"
description: "Subagent research for the 7 configuration files required before application code in the OPS Program Approval demo scaffolding project."
author: researcher-subagent
ms.date: 2026-03-02
ms.topic: reference
---

## Summary

This document provides deep research on the 7 configuration layer files that must be scaffolded before any application code is written for the OPS Program Approval System (Developer Day 2026, 130-minute demo). Each section includes a content specification, best practices, rationale, discovered patterns, pitfalls, and example snippets.

## 1. `.gitignore`

### Content Specification

The `.gitignore` must cover four stacks simultaneously: Java/Maven, Node/Vite, IDE artifacts, and OS-generated files. The order should group by category with comment headers for readability.

### Best Practices and Rationale

Combining rules from multiple stacks into a single file is the standard approach for monorepo and multi-project repositories. The gitignore.io service (toptal.com/developers/gitignore) generates comprehensive templates, but the output is verbose. A curated, hand-maintained file specific to this stack is preferable because:

* It avoids dozens of irrelevant entries (e.g., Gradle when using Maven).
* It documents intent via comment blocks.
* It reduces noise during demo walkthroughs where the audience reads the file.

### Required Patterns

#### Java / Maven

| Pattern | Reason |
|---------|--------|
| `target/` | Maven build output directory |
| `*.class` | Compiled Java bytecode |
| `*.jar` | Built/packaged archives |
| `*.war` | Web archives |
| `*.ear` | Enterprise archives (completeness) |
| `.gradle/` | Gradle cache (guard against accidental use) |
| `build/` | Gradle build output |
| `!**/src/main/**/build/` | Exception: do not ignore source directories named build |
| `!**/src/test/**/build/` | Exception: same for test source |
| `*.log` | Application and Spring Boot log files |
| `hs_err_pid*` | JVM crash dump files |
| `replay_pid*` | JVM replay files (Java 21+) |
| `.mvn/timing.properties` | Maven wrapper timing artifact |
| `.mvn/wrapper/maven-wrapper.jar` | Binary JAR not needed when using `mvnw` download |

> [!NOTE]
> The Maven wrapper shell scripts (`mvnw`, `mvnw.cmd`) and `.mvn/wrapper/maven-wrapper.properties` should be committed. Only the downloaded JAR should be ignored.

#### Node / Vite / React

| Pattern | Reason |
|---------|--------|
| `node_modules/` | npm dependency tree (never commit) |
| `dist/` | Vite production build output |
| `.env` | Environment variables (may contain secrets) |
| `.env.local` | Local-only environment overrides |
| `.env.*.local` | Per-environment local overrides |
| `*.local` | Vite uses `.local` suffix for local-only config |
| `coverage/` | Test coverage reports |
| `.eslintcache` | ESLint cache file |

#### IDE

| Pattern | Reason |
|---------|--------|
| `.idea/` | IntelliJ IDEA project settings |
| `*.iml` | IntelliJ module files |
| `*.iws` | IntelliJ workspace files |
| `.vscode/settings.json` | User-specific VS Code settings |
| `.vscode/launch.json` | Debug configurations (may contain local paths) |
| `.project` | Eclipse project file |
| `.classpath` | Eclipse classpath file |
| `.settings/` | Eclipse settings directory |
| `*.swp` | Vim swap files |
| `*~` | Backup files from various editors |
| `.factorypath` | Eclipse annotation processing |
| `*.ipr` | IntelliJ legacy project format |

> [!IMPORTANT]
> `.vscode/mcp.json` and `.vscode/extensions.json` must NOT be ignored. They are shared project configuration. Only `settings.json` and `launch.json` (user-specific) should be ignored.

#### OS

| Pattern | Reason |
|---------|--------|
| `.DS_Store` | macOS Finder metadata |
| `Thumbs.db` | Windows Explorer thumbnail cache |
| `desktop.ini` | Windows folder settings |
| `ehthumbs.db` | Windows legacy thumbnail cache |

### Potential Pitfalls

* Forgetting to ignore `*.local` causes Vite local config files to be committed.
* Ignoring all of `.vscode/` prevents sharing `mcp.json` and `extensions.json`.
* The `build/` pattern can conflict with source directories named "build" in multi-module projects; use negation patterns.
* `hs_err_pid*` and `replay_pid*` are easy to miss but pollute the repository when JVM crashes occur.

### Example Content

```gitignore
# === Java / Maven ===
target/
*.class
*.jar
*.war
*.ear
!**/src/main/**/build/
!**/src/test/**/build/
*.log
hs_err_pid*
replay_pid*
.mvn/timing.properties
.mvn/wrapper/maven-wrapper.jar

# === Node / Vite ===
node_modules/
dist/
.env
.env.local
.env.*.local
*.local
coverage/
.eslintcache

# === IDE ===
.idea/
*.iml
*.iws
*.ipr
.vscode/settings.json
.vscode/launch.json
.project
.classpath
.settings/
.factorypath
*.swp
*~

# === OS ===
.DS_Store
Thumbs.db
desktop.ini
ehthumbs.db
```

---

## 2. `.vscode/mcp.json`

### Content Specification

This file configures the MCP (Model Context Protocol) server for Azure DevOps integration within VS Code. It enables Copilot Agent Mode to interact with Azure DevOps directly from the editor.

### Key Discovery: Official Package

Research revealed two competing packages:

| Package | Version | Maintainer | Capabilities |
|---------|---------|------------|-------------|
| `azure-devops-mcp` | 1.1.2 | elad-nofy (community) | READ-ONLY; builds, work items, releases, git, pipelines, test results |
| `@azure-devops/mcp` | 2.4.0 | Microsoft (official) | Full CRUD; work items, repos, wikis, test plans, pipelines, advanced security |

The user's request referenced `azure-devops-mcp`, but the official Microsoft package `@azure-devops/mcp` v2.4.0 is the correct choice. It is maintained by the Microsoft Azure DevOps team (github.com/microsoft/azure-devops-mcp), has 1.3k stars, 41 contributors, and supports full read/write access.

### Schema

The `.vscode/mcp.json` schema supports three top-level fields:

* `inputs`: Array of input variable definitions (id, type, description) that VS Code prompts for at runtime.
* `servers`: Object mapping server names to server configurations.
* Each server has: `type` ("stdio"), `command`, `args`, and optionally `env` and `cwd`.

### Domains

The official MCP server supports domain filtering via the `-d` argument:

| Domain | Tools |
|--------|-------|
| `core` | Projects, teams, iterations, areas |
| `work` | Boards, backlogs, sprint management |
| `work-items` | Work item CRUD, queries (WIQL) |
| `search` | Code search across repos |
| `test-plans` | Test plans, suites, cases, runs |
| `repositories` | Repos, branches, commits, PRs, diffs |
| `wiki` | Wiki pages CRUD |
| `pipelines` | Pipeline runs, YAML config, variables |
| `advanced-security` | GHAS-related operations |

All domains are loaded by default. For this demo, all domains are relevant.

### Authentication

The official package uses browser-based Microsoft account authentication (no PAT required). The first time an ADO tool is executed, a browser opens for login.

### Best Practices

* Hardcode the organization name rather than using `${input:ado_org}` since this is a project-specific config file shared across team members.
* Do not include PATs or secrets (browser auth handles authentication).
* The Microsoft README recommends adding a line to `copilot-instructions.md`: "This project uses Azure DevOps. Always check to see if the Azure DevOps MCP server has a tool relevant to the user's request."

### Example Content

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": ["-y", "@azure-devops/mcp", "MngEnvMCAP675646"]
    }
  }
}
```

### Alternative with Domain Filtering

```json
{
  "servers": {
    "ado": {
      "type": "stdio",
      "command": "npx",
      "args": [
        "-y",
        "@azure-devops/mcp",
        "MngEnvMCAP675646",
        "-d", "core", "work", "work-items", "repositories", "test-plans", "pipelines"
      ]
    }
  }
}
```

### Potential Pitfalls

* Using the community `azure-devops-mcp` package instead of the official `@azure-devops/mcp` loses write capabilities and Microsoft support.
* The `inputs` array approach prompts users each time; hardcoding the org is more demo-friendly.
* Node.js 20+ is required for the official package.
* Forgetting to ignore `.vscode/settings.json` while keeping `.vscode/mcp.json` tracked can cause confusion.

---

## 3. `.github/copilot-instructions.md`

### Content Specification

This is the global Copilot context file. VS Code automatically loads it for every Copilot interaction in the repository. It provides overarching project context that Copilot uses to generate relevant, conventions-compliant code.

### Standard Structure

The file does not use `applyTo` frontmatter (it applies globally by default). The recommended structure from both VS Code documentation and the project's README is:

1. Frontmatter with `description`
2. Project overview
3. Tech stack summary
4. Key conventions (bilingual, accessibility, design system)
5. Azure DevOps integration patterns
6. References to domain-specific instruction files

### Best Practices

* Keep this file concise (under 2000 tokens). Copilot loads it for every interaction, so excessive content dilutes relevance.
* Reference the domain-specific `.instructions.md` files for stack-specific guidance rather than duplicating content.
* Include the ADO MCP recommendation: "This project uses Azure DevOps. Always check to see if the Azure DevOps MCP server has a tool relevant to the user's request."
* State explicit conventions that apply across all files (commit format, branch naming, bilingual requirement).
* Do not include code examples here; those belong in the stack-specific instruction files.

### Required Content Elements

* Project name and purpose: OPS Program Approval System for Developer Day 2026
* Tech stack table: React 18 + TypeScript (frontend), Java 21 + Spring Boot 3.x (backend), Azure SQL (database), Azure services (cloud)
* Bilingual EN/FR requirement: all user-facing text must use i18next with `en.json` and `fr.json` translation files
* WCAG 2.2 Level AA: all UI components must meet accessibility standards
* Ontario Design System: use ontario-design-system CSS classes
* ADO integration: commit format `AB#{id} <description>`, branch naming `feature/{id}-description`, PR linking `Fixes AB#{id}`
* Project structure: `frontend/` for React, `backend/` for Java, `database/` for SQL migrations
* Azure DevOps MCP tool reference

### Potential Pitfalls

* Making this file too long reduces Copilot effectiveness (token dilution).
* Omitting the ADO MCP tool reference means Copilot will not use available ADO tools.
* Conflicting instructions between this file and the stack-specific files causes inconsistent output.
* The file must NOT have an `applyTo` field; it applies globally by convention.

### Example Content

```markdown
---
description: "Global Copilot instructions for the OPS Program Approval System"
---

## Project Overview

This is the OPS Program Approval System for Developer Day 2026, enabling Ontario citizens to submit program requests and Ministry employees to review and approve them.

## Tech Stack

| Layer      | Technology                              |
|------------|-----------------------------------------|
| Frontend   | React 18, TypeScript, Vite (port 3000)  |
| Backend    | Java 21, Spring Boot 3.x, Spring Data JPA (port 8080) |
| Database   | Azure SQL (H2 locally with MODE=MSSQLServer)           |
| Cloud      | Azure App Services, Durable Functions, Logic Apps, AI Foundry |
| CI/CD      | GitHub Actions                          |
| Project    | Azure DevOps (org: MngEnvMCAP675646, project: ProgramDemo-DevDay2026-DryRun2) |

## Cross-Cutting Requirements

All user-facing text must be bilingual (English and French) using i18next with en.json and fr.json translation files. Never hardcode display strings in components.

All UI must meet WCAG 2.2 Level AA accessibility standards: semantic HTML, aria attributes, keyboard navigation, sufficient color contrast (4.5:1 for normal text), and lang attribute on the html element.

Use Ontario Design System CSS classes for all UI components. Follow the ontario.ca template layout.

## Azure DevOps Workflow

This project uses Azure DevOps. Always check to see if the Azure DevOps MCP server has a tool relevant to the user's request.

Commit messages: AB#{id} description (e.g., AB#42 add program submission form).

Branch naming: feature/{id}-description (e.g., feature/42-program-submission-form).

PR descriptions: include Fixes AB#{id} to auto-link work items.

Delete feature branches after merge.

## Project Structure

frontend/ contains the React application.
backend/ contains the Java Spring Boot API.
database/ contains Flyway SQL migration scripts.
```

---

## 4. `.github/instructions/ado-workflow.instructions.md`

### Content Specification

This instruction file applies to all files (`applyTo: **`) and defines the Azure DevOps integration workflow conventions.

### Frontmatter Format

Instruction files use YAML frontmatter with two required fields:

```yaml
---
description: "Brief description of what these instructions cover"
applyTo: "glob pattern"
---
```

The `applyTo` field accepts VS Code glob patterns: `**` matches all files, `backend/**` matches all files under backend/, `**/*.java` matches all Java files.

### Required Content

* Branching model: create feature branches from `main` using `feature/{id}-description` format
* Commit message format: `AB#{id} <description>` where `{id}` is the Azure DevOps work item ID
* PR conventions: include `Fixes AB#{id}` in the PR description body to auto-link and auto-complete work items
* Post-merge cleanup: delete the feature branch after PR merge
* Work item linkage: every commit and PR should reference an ADO work item
* Sprint workflow: pull work items from the current iteration

### ADO Integration Patterns

Azure DevOps recognizes specific patterns in commit messages and PR descriptions:

| Pattern | Effect |
|---------|--------|
| `AB#{id}` in commit message | Links commit to work item |
| `Fixes AB#{id}` in PR description | Links PR and transitions work item to Done on merge |
| `AB#{id}` in branch name | No automatic linking (informational only) |

The `AB#` prefix is the Azure DevOps artifact link syntax for Azure Boards. It works across GitHub-to-ADO integration when the GitHub connection is configured in ADO project settings.

### Best Practices

* Include the work item ID in both the branch name AND commit message for traceability.
* Use imperative mood in commit descriptions ("add form validation" not "added form validation").
* Keep commit messages under 72 characters for the subject line.
* One work item per branch prevents tangled PRs.

### Potential Pitfalls

* `AB#{id}` syntax requires the Azure Boards GitHub integration to be configured in the ADO project. Without it, the links are cosmetic only.
* Using `Closes` instead of `Fixes` may not trigger the ADO integration (verify with the specific ADO configuration).
* Forgetting to delete feature branches after merge clutters the repository.

### Example Content

```markdown
---
description: "Azure DevOps workflow conventions for branching, commits, and pull requests"
applyTo: '**'
---

## ADO Workflow Instructions

### Branching

Create feature branches from main using the format feature/{id}-description where {id} is the Azure DevOps work item ID.

### Commits

Format every commit message as AB#{id} description using imperative mood. Keep the subject line under 72 characters.

### Pull Requests

Include Fixes AB#{id} in the PR description to auto-link and transition the work item on merge. Use the format:

Title: AB#{id} description
Body: Fixes AB#{id} followed by a summary of changes.

### Post-Merge

Delete the feature branch after the PR is merged. The main branch should always be deployable.
```

---

## 5. `.github/instructions/java.instructions.md`

### Content Specification

This instruction file applies to `backend/**` and guides Copilot when generating Java/Spring Boot code.

### Spring Boot 3.x Best Practices (Current as of 2026)

#### ProblemDetail (RFC 7807)

Spring Boot 3.x has native support for RFC 7807 Problem Details via `ProblemDetail` class and `@ControllerAdvice`:

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(EntityNotFoundException.class)
    public ProblemDetail handleNotFound(EntityNotFoundException ex) {
        ProblemDetail problem = ProblemDetail.forStatusAndDetail(
            HttpStatus.NOT_FOUND, ex.getMessage());
        problem.setTitle("Resource Not Found");
        problem.setType(URI.create("https://api.ontario.ca/problems/not-found"));
        return problem;
    }
}
```

Enable in `application.yml`:

```yaml
spring:
  mvc:
    problemdetails:
      enabled: true
```

#### Constructor Injection

Spring Boot 3.x eliminates the need for `@Autowired` when a class has a single constructor. Constructor injection is the recommended pattern because:

* It makes dependencies explicit and immutable (`final` fields).
* It enables easier unit testing (pass mocks directly).
* It fails fast if a dependency is missing (compile-time vs. runtime).

```java
@Service
public class ProgramService {
    private final ProgramRepository programRepository;

    public ProgramService(ProgramRepository programRepository) {
        this.programRepository = programRepository;
    }
}
```

#### Bean Validation

Standard annotations for DTOs:

| Annotation | Use Case |
|------------|----------|
| `@NotNull` | Required fields |
| `@NotBlank` | Required non-empty strings |
| `@Size(min, max)` | String length constraints |
| `@Email` | Email format validation |
| `@Pattern(regexp)` | Custom regex validation |
| `@Min`, `@Max` | Numeric range constraints |
| `@Valid` | Cascade validation to nested objects |

Apply `@Valid` on controller method parameters:

```java
@PostMapping("/programs")
public ResponseEntity<ProgramDto> create(@Valid @RequestBody ProgramCreateDto dto) {
    // ...
}
```

### Recommended Project Structure

```text
backend/
├── src/main/java/com/ontario/program/
│   ├── ProgramApplication.java
│   ├── config/
│   │   ├── SecurityConfig.java
│   │   └── WebConfig.java
│   ├── controller/
│   │   └── ProgramController.java
│   ├── dto/
│   │   ├── ProgramCreateDto.java
│   │   └── ProgramDto.java
│   ├── exception/
│   │   └── GlobalExceptionHandler.java
│   ├── model/
│   │   └── Program.java
│   ├── repository/
│   │   └── ProgramRepository.java
│   └── service/
│       └── ProgramService.java
├── src/main/resources/
│   ├── application.yml
│   ├── application-local.yml
│   └── db/migration/
│       └── V001__create_programs_table.sql
└── src/test/java/com/ontario/program/
```

### H2 Local Profile

The `application-local.yml` should configure H2 in MSSQLServer compatibility mode:

```yaml
spring:
  datasource:
    url: jdbc:h2:mem:programdb;MODE=MSSQLServer;DATABASE_TO_LOWER=TRUE
    driver-class-name: org.h2.Driver
    username: sa
    password:
  h2:
    console:
      enabled: true
  jpa:
    hibernate:
      ddl-auto: validate
    show-sql: true
  flyway:
    enabled: true
```

The `MODE=MSSQLServer` flag makes H2 behave like SQL Server for:

* `IDENTITY` columns
* `NVARCHAR` type handling
* T-SQL syntax compatibility (partial)

### Potential Pitfalls

* Field injection (`@Autowired` on fields) compiles but is untestable and hides dependencies.
* Omitting `@Valid` on controller parameters silently skips validation.
* H2 `MODE=MSSQLServer` does not support all T-SQL features (e.g., `IF NOT EXISTS` syntax differs). Flyway migrations should use standard SQL where possible with T-SQL extensions only where required.
* The base package `com.ontario.program` must be at or above the `@SpringBootApplication` class for component scanning.
* `ddl-auto` should be `validate` (not `update` or `create-drop`) when using Flyway, to prevent Hibernate from modifying the schema alongside Flyway.

### Example Instructions Content

```markdown
---
description: "Java 21 and Spring Boot 3.x conventions for the backend API"
applyTo: 'backend/**'
---

## Java Instructions

Base package: com.ontario.program

Use Java 21 features where appropriate (records for DTOs, pattern matching, text blocks).

Use constructor injection exclusively. Do not use @Autowired on fields.

Return ResponseEntity from all controller methods with appropriate HTTP status codes.

Validate all incoming DTOs with @Valid and Bean Validation annotations (@NotBlank, @Size, @NotNull).

Use ProblemDetail (RFC 7807) for all error responses via a @RestControllerAdvice global exception handler.

Use Spring Data JPA repositories extending JpaRepository.

Use Flyway for database migrations. Place migration files in src/main/resources/db/migration/.

Configure the local profile with H2 in MODE=MSSQLServer for Azure SQL compatibility.
```

---

## 6. `.github/instructions/react.instructions.md`

### Content Specification

This instruction file applies to `frontend/**` and guides Copilot when generating React/TypeScript code.

### Ontario Design System

The Ontario Design System (designsystem.ontario.ca) provides CSS classes and components for government web applications. Key classes used in this project:

| Component | CSS Class / Pattern |
|-----------|-------------------|
| Page container | `ontario-page__container` |
| Header | `ontario-header` |
| Footer | `ontario-footer` |
| Buttons (primary) | `ontario-button ontario-button--primary` |
| Buttons (secondary) | `ontario-button ontario-button--secondary` |
| Form inputs | `ontario-input` |
| Form labels | `ontario-label` |
| Form groups | `ontario-form-group` |
| Fieldset | `ontario-fieldset` |
| Select dropdown | `ontario-select` |
| Textarea | `ontario-textarea` |
| Checkboxes | `ontario-checkboxes` |
| Radio buttons | `ontario-radios` |
| Error messages | `ontario-input__error` |
| Hint text | `ontario-hint` |
| Alerts (info) | `ontario-alert ontario-alert--informational` |
| Alerts (warning) | `ontario-alert ontario-alert--warning` |
| Alerts (error) | `ontario-alert ontario-alert--error` |
| Alerts (success) | `ontario-alert ontario-alert--success` |
| Breadcrumbs | `ontario-breadcrumbs` |
| Step indicator | `ontario-step-indicator` |
| Loading indicator | `ontario-loading-indicator` |

The design system is available as an npm package: `@ongov/ontario-design-system-global-styles`.

### i18next Configuration for EN/FR

Required packages: `i18next`, `react-i18next`, `i18next-browser-languagedetector`.

Configuration pattern:

```typescript
import i18n from 'i18next';
import { initReactI18next } from 'react-i18next';
import LanguageDetector from 'i18next-browser-languagedetector';
import en from './locales/en.json';
import fr from './locales/fr.json';

i18n
  .use(LanguageDetector)
  .use(initReactI18next)
  .init({
    resources: {
      en: { translation: en },
      fr: { translation: fr }
    },
    fallbackLng: 'en',
    supportedLngs: ['en', 'fr'],
    interpolation: {
      escapeValue: false
    }
  });

export default i18n;
```

Translation file structure (`en.json` / `fr.json`):

```json
{
  "common": {
    "submit": "Submit",
    "cancel": "Cancel",
    "save": "Save",
    "back": "Back"
  },
  "program": {
    "title": "Program Approval Request",
    "name": "Program Name",
    "description": "Program Description",
    "type": "Program Type"
  },
  "validation": {
    "required": "This field is required",
    "maxLength": "Must be {{max}} characters or fewer"
  }
}
```

Usage in components:

```tsx
import { useTranslation } from 'react-i18next';

const ProgramForm: React.FC = () => {
  const { t } = useTranslation();
  return <h1>{t('program.title')}</h1>;
};
```

### WCAG 2.2 Level AA Requirements

The most relevant WCAG 2.2 requirements for forms and navigation:

| Criterion | ID | Requirement |
|-----------|----|-------------|
| Non-text Content | 1.1.1 | All images have alt text |
| Info and Relationships | 1.3.1 | Form fields linked to labels with `htmlFor`/`id` |
| Meaningful Sequence | 1.3.2 | DOM order matches visual order |
| Use of Color | 1.4.1 | Color is not the sole indicator of state |
| Contrast (Minimum) | 1.4.3 | 4.5:1 ratio for normal text, 3:1 for large text |
| Resize Text | 1.4.4 | Content readable at 200% zoom |
| Keyboard | 2.1.1 | All functionality operable via keyboard |
| No Keyboard Trap | 2.1.2 | Focus can be moved away from every component |
| Page Titled | 2.4.2 | Each page has a descriptive title |
| Focus Visible | 2.4.7 | Keyboard focus indicator is visible |
| Language of Page | 3.1.1 | `lang` attribute on html element |
| Language of Parts | 3.1.2 | Lang attribute on elements with different language |
| On Input | 3.2.2 | No unexpected context changes on input |
| Error Identification | 3.3.1 | Errors described in text (not just color) |
| Labels or Instructions | 3.3.2 | Form fields have visible labels |
| Error Suggestion | 3.3.3 | Provide suggestions when errors are detected |
| Focus Not Obscured | 2.4.11 | Focused element is not hidden behind other content (new in 2.2) |
| Dragging Movements | 2.5.7 | Drag actions have non-dragging alternatives (new in 2.2) |

### Vite Configuration

```typescript
// vite.config.ts
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
  plugins: [react()],
  server: {
    port: 3000,
    proxy: {
      '/api': {
        target: 'http://localhost:8080',
        changeOrigin: true
      }
    }
  }
});
```

### Best Practices

* Use functional components exclusively (no class components).
* Use named exports for components (not default exports) for better refactoring and import clarity.
* Use `React.FC` or plain function syntax with typed props.
* Use `useState`, `useEffect`, `useCallback`, `useMemo` hooks.
* Keep components small and focused (under 150 lines).
* Co-locate related files (component, styles, tests) in feature directories.
* Use `react-router-dom` v6 with `createBrowserRouter` and `RouterProvider`.
* Use `axios` with a centralized API client for all HTTP calls.
* All form inputs must have associated labels with `htmlFor`/`id` pairing.
* Set `lang="en"` or `lang="fr"` on the `<html>` element dynamically based on the selected language.
* Use TypeScript strict mode (`"strict": true` in tsconfig.json).

### Potential Pitfalls

* Hardcoding English strings bypasses the i18next system and breaks French localization.
* Missing `aria-label` or `aria-describedby` on interactive elements fails WCAG.
* Using `div` with `onClick` instead of `button` breaks keyboard accessibility.
* The Ontario Design System CSS may conflict with other CSS resets; load it before application styles.
* Vite port 3000 may conflict with other dev servers; explicit configuration prevents surprises.

### Example Instructions Content

```markdown
---
description: "React 18 with TypeScript conventions for the frontend application"
applyTo: 'frontend/**'
---

## React Instructions

Use React 18 with TypeScript in strict mode. Use Vite as the build tool with server.port set to 3000.

Use functional components with hooks only. No class components.

All user-facing text must use the useTranslation hook from react-i18next. Never hardcode display strings. Translation keys live in frontend/src/locales/en.json and fr.json.

Use Ontario Design System CSS classes for all UI components (ontario-button, ontario-input, ontario-form-group, ontario-header, ontario-footer).

Meet WCAG 2.2 Level AA: use semantic HTML elements, associate labels with inputs via htmlFor/id, provide aria attributes on interactive elements, ensure keyboard navigability, and maintain 4.5:1 contrast ratio.

Set the lang attribute on the html element dynamically based on the selected language.

Use react-router-dom v6 for routing. Use axios for HTTP requests with a centralized API client.
```

---

## 7. `.github/instructions/sql.instructions.md`

### Content Specification

This instruction file applies to `database/**` and guides Copilot when generating SQL migration scripts.

### Flyway Naming Conventions

Flyway versioned migration filenames follow the pattern:

```text
V{version}__{description}.sql
```

Rules:

* `V` prefix is mandatory for versioned migrations.
* Version numbers: use zero-padded integers (e.g., `V001`, `V002`, `V003`) for consistent sorting, or dot-separated versions (`V1.0.1`). Zero-padded integers are simpler for this project.
* Double underscore (`__`) separates version from description.
* Description uses underscores for word separation (e.g., `create_programs_table`).
* No spaces in filenames.
* Migrations are immutable once applied; never modify an existing migration.

Examples:

```text
V001__create_programs_table.sql
V002__create_program_types_table.sql
V003__seed_program_types.sql
V004__add_status_column.sql
```

### Azure SQL Data Types

| Concept | Type | Rationale |
|---------|------|-----------|
| Bilingual text (short) | `NVARCHAR(255)` | Unicode support for EN/FR characters |
| Bilingual text (long) | `NVARCHAR(MAX)` | Long-form bilingual descriptions |
| Primary key | `INT IDENTITY(1,1)` | Auto-incrementing integer |
| Timestamps | `DATETIME2` | Higher precision than `DATETIME`, recommended for Azure SQL |
| Boolean flags | `BIT` | Azure SQL standard for true/false |
| Money/currency | `DECIMAL(18,2)` | Precise decimal storage |
| Status enums | `NVARCHAR(50)` | String-based enums for readability |

### IF NOT EXISTS Guards

T-SQL `IF NOT EXISTS` guards prevent re-execution errors:

```sql
-- Table creation guard
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'programs')
BEGIN
    CREATE TABLE programs (
        id INT IDENTITY(1,1) PRIMARY KEY,
        program_name_en NVARCHAR(255) NOT NULL,
        program_name_fr NVARCHAR(255) NOT NULL,
        created_at DATETIME2 DEFAULT GETDATE(),
        updated_at DATETIME2 DEFAULT GETDATE()
    );
END
```

```sql
-- Column addition guard
IF NOT EXISTS (
    SELECT * FROM sys.columns
    WHERE object_id = OBJECT_ID('programs') AND name = 'status'
)
BEGIN
    ALTER TABLE programs ADD status NVARCHAR(50) NOT NULL DEFAULT 'draft';
END
```

### Why Avoid MERGE for Seed Data

The `MERGE` statement in SQL Server has known issues:

* Documented bugs in concurrent scenarios (KB articles exist for data corruption).
* Complex syntax increases the risk of subtle errors.
* Not atomic without explicit transaction wrapping.
* Paul White (SQL Server MVP) and Aaron Bertrand have published detailed analyses of MERGE bugs.

The safe alternative is `INSERT ... WHERE NOT EXISTS`:

```sql
INSERT INTO program_types (code, name_en, name_fr)
SELECT 'SOCIAL', N'Social Program', N'Programme social'
WHERE NOT EXISTS (
    SELECT 1 FROM program_types WHERE code = 'SOCIAL'
);
```

This pattern is:

* Idempotent (safe to re-run).
* No known bugs.
* Readable and auditable.
* Works identically on Azure SQL and H2 in MSSQLServer mode.

### Audit Columns

Standard audit columns for tables that need traceability:

```sql
created_at  DATETIME2 NOT NULL DEFAULT GETDATE(),
updated_at  DATETIME2 NOT NULL DEFAULT GETDATE(),
created_by  NVARCHAR(255) NULL
```

For `updated_at`, use a trigger or application-level update (Spring Data JPA `@PreUpdate` lifecycle callbacks are recommended over triggers for this project).

### H2 Compatibility Notes

H2 in `MODE=MSSQLServer` supports:

* `IDENTITY(1,1)` syntax
* `NVARCHAR` type
* `DATETIME2` (mapped to TIMESTAMP)
* `GETDATE()` function

H2 does NOT support:

* `sys.tables` / `sys.columns` system views (use `INFORMATION_SCHEMA` instead for H2, or use Flyway's versioning to avoid needing guards)
* Full T-SQL procedural syntax (complex IF/ELSE blocks)
* Some SQL Server-specific functions

Since Flyway tracks which migrations have run, `IF NOT EXISTS` guards are technically redundant for normal flow. They serve as safety nets for manual re-execution or disaster recovery scenarios. For H2 compatibility, prefer letting Flyway handle idempotency and reserve T-SQL-specific guards for production Azure SQL scripts.

### Best Practices

* One logical change per migration file.
* Every table should have a primary key.
* Use `NVARCHAR` for all text columns (bilingual requirement).
* Include `NOT NULL` constraints where appropriate with meaningful defaults.
* Name constraints explicitly (e.g., `PK_programs`, `FK_programs_program_type`).
* Add indexes for frequently queried columns.
* Seed data goes in separate migration files from schema changes.

### Potential Pitfalls

* Using `VARCHAR` instead of `NVARCHAR` breaks French characters with accents (è, é, ç, ô, etc.).
* Using `DATETIME` instead of `DATETIME2` loses precision and is deprecated for new development.
* Editing an already-applied migration causes Flyway checksum errors.
* `MERGE` statements can cause data corruption under concurrent load.
* H2 compatibility requires avoiding `sys.*` system views in migrations.

### Example Instructions Content

```markdown
---
description: "SQL conventions for Azure SQL database migrations"
applyTo: 'database/**'
---

## SQL Instructions

Target database: Azure SQL (H2 locally with MODE=MSSQLServer).

Use Flyway versioned migrations named V001__description.sql, V002__description.sql, etc.

Use NVARCHAR for all text columns to support bilingual EN/FR content. Use NVARCHAR(255) for short text and NVARCHAR(MAX) for long text.

Use INT IDENTITY(1,1) for primary keys. Use DATETIME2 for all timestamp columns.

Include IF NOT EXISTS guards on CREATE TABLE and ALTER TABLE statements for safety.

Use INSERT ... WHERE NOT EXISTS for seed data. Never use MERGE.

Include audit columns (created_at DATETIME2, updated_at DATETIME2, created_by NVARCHAR(255)) on tables that require traceability.

Name constraints explicitly: PK_tablename for primary keys, FK_tablename_reference for foreign keys.

One logical change per migration file. Never modify an already-applied migration.
```

---

## Research Findings Summary

### Key Discoveries

1. The official Azure DevOps MCP package is `@azure-devops/mcp` v2.4.0 (by Microsoft), not the community `azure-devops-mcp` v1.1.2. The official package supports full CRUD operations, domain filtering, and browser-based auth (no PAT needed).

2. The official MCP server supports 9 domains (core, work, work-items, search, test-plans, repositories, wiki, pipelines, advanced-security) that can be selectively enabled via the `-d` argument.

3. Spring Boot 3.x `ProblemDetail` is a first-class feature that implements RFC 7807, enabled via `spring.mvc.problemdetails.enabled: true`.

4. H2 `MODE=MSSQLServer` has known limitations: no `sys.tables`/`sys.columns` views, limited T-SQL procedural support. Flyway's version tracking reduces the need for `IF NOT EXISTS` guards in development.

5. SQL Server `MERGE` has documented concurrency bugs. `INSERT ... WHERE NOT EXISTS` is the recommended idempotent pattern for seed data.

6. The Ontario Design System provides an npm package (`@ongov/ontario-design-system-global-styles`) and a comprehensive set of CSS classes following the ontario.ca template.

7. WCAG 2.2 adds new criteria over 2.1, including Focus Not Obscured (2.4.11) and Dragging Movements (2.5.7), both relevant for form-heavy government applications.

### Recommended Next Research

* DevContainer configuration (`.devcontainer/devcontainer.json`) for Java 21 + Node 20 environment.
* GitHub Actions CI workflow structure for dual-stack (Maven + npm) builds.
* Azure SQL connection string configuration for the deployed environment.
* Ontario Design System npm package version and integration with Vite.
* Figma-to-code workflow and design token extraction.

### Open Questions

* Should the MCP config include domain filtering, or should all domains be loaded by default for maximum flexibility during the demo?
* Should `.vscode/extensions.json` be included in the configuration layer to recommend required VS Code extensions?
* Should a `.editorconfig` file be added for consistent formatting across IDEs?
* Is a `docker-compose.yml` needed for local Azure SQL emulation, or is H2 sufficient for the demo?
