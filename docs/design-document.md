---
title: "Design Document"
description: "API specifications, DTOs, error handling, and frontend component hierarchy for the OPS Program Approval application"
---

# Design Document

## API Endpoints

### POST /api/programs

Submit a new program for approval.

| Attribute | Value |
|-----------|-------|
| **Description** | Creates a new program with status `SUBMITTED` |
| **Request Body** | `ProgramSubmitRequest` |
| **Response Body** | `ProgramResponse` |
| **Status Codes** | `201 Created`, `400 Bad Request`, `500 Internal Server Error` |

### GET /api/programs

List all programs with optional filtering.

| Attribute | Value |
|-----------|-------|
| **Description** | Returns all programs, optionally filtered by status or search term |
| **Query Parameters** | `status` (optional): Filter by status (`SUBMITTED`, `APPROVED`, `REJECTED`)<br/>`search` (optional): Search in program name or description |
| **Response Body** | `ProgramResponse[]` |
| **Status Codes** | `200 OK` |

### GET /api/programs/{id}

Get a single program by ID.

| Attribute | Value |
|-----------|-------|
| **Description** | Returns a single program by its ID |
| **Path Parameters** | `id`: Program ID |
| **Response Body** | `ProgramResponse` |
| **Status Codes** | `200 OK`, `404 Not Found` |

### PUT /api/programs/{id}/review

Approve or reject a program.

| Attribute | Value |
|-----------|-------|
| **Description** | Updates program status to `APPROVED` or `REJECTED` with reviewer comments |
| **Path Parameters** | `id`: Program ID |
| **Request Body** | `ProgramReviewRequest` |
| **Response Body** | `ProgramResponse` |
| **Status Codes** | `200 OK`, `400 Bad Request`, `404 Not Found`, `409 Conflict` |

> **Note:** Returns `409 Conflict` if the program has already been reviewed (status is not `SUBMITTED`).

### GET /api/program-types

Get all program types for dropdown population.

| Attribute | Value |
|-----------|-------|
| **Description** | Returns all program types with bilingual names |
| **Response Body** | `ProgramTypeResponse[]` |
| **Status Codes** | `200 OK` |

## Request DTOs

### ProgramSubmitRequest

```java
public record ProgramSubmitRequest(
    @NotBlank(message = "Program name is required")
    @Size(max = 200, message = "Program name must not exceed 200 characters")
    String programName,

    @NotBlank(message = "Program description is required")
    String programDescription,

    @NotNull(message = "Program type is required")
    Integer programTypeId,

    @Size(max = 100, message = "Created by must not exceed 100 characters")
    String createdBy
) {}
```

### ProgramReviewRequest

```java
public record ProgramReviewRequest(
    @NotBlank(message = "Status is required")
    @Pattern(regexp = "APPROVED|REJECTED", message = "Status must be APPROVED or REJECTED")
    String status,

    String reviewerComments
) {}
```

## Response DTOs

### ProgramResponse

```java
public record ProgramResponse(
    Integer id,
    String programName,
    String programDescription,
    Integer programTypeId,
    String programTypeName,    // English name
    String programTypeNameFr,  // French name
    String status,
    String reviewerComments,
    LocalDateTime submittedAt,
    LocalDateTime reviewedAt,
    LocalDateTime createdAt,
    LocalDateTime updatedAt,
    String createdBy
) {}
```

> **Note:** Response includes both English (`programTypeName`) and French (`programTypeNameFr`) type names. The frontend selects the appropriate language based on the user's `i18n` setting.

### ProgramTypeResponse

```java
public record ProgramTypeResponse(
    Integer id,
    String typeName,    // English name
    String typeNameFr   // French name
) {}
```

## RFC 7807 Error Responses

All error responses follow the RFC 7807 `ProblemDetail` format.

### 400 Bad Request — Validation Error

```json
{
  "type": "about:blank",
  "title": "Validation Failed",
  "status": 400,
  "detail": "programName: Program name is required, programTypeId: Program type is required",
  "instance": "/api/programs"
}
```

### 404 Not Found

```json
{
  "type": "about:blank",
  "title": "Not Found",
  "status": 404,
  "detail": "Program with id 999 not found",
  "instance": "/api/programs/999"
}
```

### 409 Conflict — Already Reviewed

```json
{
  "type": "about:blank",
  "title": "Conflict",
  "status": 409,
  "detail": "Program has already been reviewed and cannot be modified",
  "instance": "/api/programs/123/review"
}
```

## Frontend Component Hierarchy

```text
App
└── Layout
    ├── Header
    │   └── LanguageToggle
    ├── Footer
    └── <Router Outlet>
        ├── SubmitProgram          /submit
        ├── SubmitConfirmation     /submit/confirmation
        ├── SearchPrograms         /search
        ├── ReviewDashboard        /review
        └── ReviewDetail           /review/:id
```

## Component Route Table

| Component | Route | Purpose |
|-----------|-------|---------|
| `Layout` | — | Shared header, footer, and language toggle wrapper |
| `SubmitProgram` | `/submit` | Citizen program submission form |
| `SubmitConfirmation` | `/submit/confirmation` | Success page after submission |
| `SearchPrograms` | `/search` | Public program search and listing |
| `ReviewDashboard` | `/review` | Ministry dashboard showing pending programs |
| `ReviewDetail` | `/review/:id` | Ministry detail view with approve/reject actions |

## Ontario Design System Integration

All components use Ontario Design System CSS classes for consistent government styling:

| Component Type | CSS Classes |
|----------------|-------------|
| Page container | `ontario-page__container` |
| Form group | `ontario-form-group` |
| Form label | `ontario-label` |
| Text input | `ontario-input` |
| Select dropdown | `ontario-select` |
| Textarea | `ontario-textarea` |
| Primary button | `ontario-button ontario-button--primary` |
| Secondary button | `ontario-button ontario-button--secondary` |
| Error message | `ontario-input__error` |
| Alert (info) | `ontario-alert ontario-alert--informational` |
| Alert (error) | `ontario-alert ontario-alert--error` |
| Alert (success) | `ontario-alert ontario-alert--success` |
| Data table | `ontario-table` |

## Accessibility Requirements

All components must meet WCAG 2.2 Level AA:

| Requirement | Implementation |
|-------------|----------------|
| Color contrast | Minimum 4.5:1 ratio for text (Ontario DS ensures this) |
| Keyboard navigation | All interactive elements focusable via Tab |
| Focus indicators | Visible focus ring on all focusable elements |
| Form labels | All inputs have associated `<label>` elements |
| Error identification | Errors announced to screen readers via `aria-live` |
| Language attribute | `<html lang>` set dynamically based on `i18n.language` |

## Related Documentation

- [Architecture](architecture.md) — System architecture and Azure resource overview
- [Data Dictionary](data-dictionary.md) — Database schema and seed data
