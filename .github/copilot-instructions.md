# OPS Program Approval System

## Project Overview

This is the OPS Program Approval System demo application for Developer Day 2026. It demonstrates a bilingual (English/French) government web application that enables staff to submit program approval requests and managers to review and approve them. The application showcases modern full-stack development practices with accessibility compliance.

## Tech Stack

| Layer | Technology |
|-------|------------|
| Frontend | React 18 + TypeScript + Vite |
| Backend | Java 21 + Spring Boot 3.x |
| Database | Azure SQL |
| Styling | Ontario Design System (`@ongov/ontario-design-system-global-styles`) |
| i18n | i18next with `en.json` / `fr.json` |

## Project Structure

```
frontend/     # React + TypeScript + Vite application
backend/      # Java 21 + Spring Boot 3.x REST API
database/     # Flyway migrations for Azure SQL
```

## Standards

- **Bilingual EN/FR**: All user-facing text via i18next with `en.json` and `fr.json` resource files
- **WCAG 2.2 Level AA**: Semantic HTML, aria attributes, keyboard navigation, 4.5:1 contrast ratio, `lang` attribute on `<html>`
- **Ontario Design System**: Use ontario-design-system CSS classes for consistent government styling

## Git Conventions

- **Commit**: `AB#{id} <description>` (e.g., `AB#123 Add login form validation`)
- **Branch**: `feature/{id}-description` (e.g., `feature/123-login-form`)
- **PR**: Include `Fixes AB#{id}` in the pull request description body

## Azure DevOps Integration

This project uses Azure DevOps. Always check to see if the Azure DevOps MCP server has a tool relevant to the user's request.
