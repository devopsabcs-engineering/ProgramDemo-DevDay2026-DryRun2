---
description: "Azure DevOps workflow conventions for branching, commits, and pull requests"
applyTo: '**'
---

# Azure DevOps Workflow Conventions

This document defines the branching, commit, and pull request conventions for integrating GitHub with Azure DevOps Boards.

## Conventions

| Convention | Pattern | Effect |
|------------|---------|--------|
| Branch naming | `feature/{id}-description` | Informational (no auto-linking) |
| Commit message | `AB#{id} <description>` | Links commit to ADO work item |
| PR description | `Fixes AB#{id}` | Links PR and transitions work item to Done on merge |
| Post-merge | Delete feature branch | Clean repository |
| Commit style | Imperative mood, ≤72 char subject | Git best practice |

## Examples

### Branch Naming

```text
feature/123-add-program-list-api
feature/456-implement-french-translations
bugfix/789-fix-validation-error
```

### Commit Messages

```text
AB#123 Add GET /api/programs endpoint

AB#456 Implement i18next with EN/FR translations

AB#789 Fix @NotBlank validation on programTypeId field
```

### Pull Request Description

```markdown
## Summary
Implements the program list API endpoint.

Fixes AB#123
```

## Important Notes

> **Azure Boards Integration Required:** The `AB#` syntax requires Azure Boards GitHub integration to be configured in the ADO project settings. Without this integration, the syntax will not automatically link commits or PRs to work items.

### Setting Up Azure Boards Integration

1. Navigate to Azure DevOps Project Settings
2. Select **Boards** → **GitHub connections**
3. Add the GitHub repository connection
4. Verify the connection status is active

## Commit Message Guidelines

1. **Use imperative mood:** "Add feature" not "Added feature" or "Adds feature"
2. **Keep subject line ≤72 characters:** Ensures readability in git log
3. **Separate subject from body with blank line:** When additional context is needed
4. **Reference work item in subject:** `AB#{id}` as prefix
5. **Explain why, not what:** The code shows what changed; the message explains why
