---
description: "Java 21 and Spring Boot 3.x conventions for the backend API"
applyTo: 'backend/**'
---

# Java Conventions

This document defines the Java 21 and Spring Boot 3.x conventions for the backend API.

## Conventions

| Area | Convention |
|------|-----------|
| Java version | Java 21 (records for DTOs, pattern matching, text blocks) |
| Framework | Spring Boot 3.x with Spring Data JPA |
| Base package | `com.ontario.program` |
| Injection | Constructor injection only (no `@Autowired` on fields) |
| Validation | `@Valid` + Bean Validation (`@NotBlank`, `@NotNull`, `@Size`, `@Pattern`) |
| Return types | `ResponseEntity` from all controller methods |
| Error handling | `ProblemDetail` (RFC 7807) via `@RestControllerAdvice` |
| Database dev | H2 with `MODE=MSSQLServer` in `local` profile |
| Migrations | Flyway in `src/main/resources/db/migration/` |
| DDL auto | `validate` (never `update` or `create-drop` with Flyway) |

## Project Structure

```text
backend/src/main/java/com/ontario/program/
├── ProgramApplication.java
├── config/
├── controller/
├── dto/
├── exception/
├── model/
├── repository/
└── service/
```

## H2 Local Profile Configuration

Create `application-local.yml` for local development with H2:

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
  flyway:
    enabled: true
```

## ProblemDetail Configuration

Enable RFC 7807 Problem Details for error responses:

```yaml
spring:
  mvc:
    problemdetails:
      enabled: true
```

Or implement explicitly in `@RestControllerAdvice`:

```java
@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidationException(MethodArgumentNotValidException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
        problem.setTitle("Validation Failed");
        problem.setDetail(ex.getBindingResult().getFieldErrors().stream()
            .map(e -> e.getField() + ": " + e.getDefaultMessage())
            .collect(Collectors.joining(", ")));
        return problem;
    }
}
```

## Constructor Injection Pattern

**Correct:**

```java
@Service
public class ProgramService {
    private final ProgramRepository programRepository;

    public ProgramService(ProgramRepository programRepository) {
        this.programRepository = programRepository;
    }
}
```

**Incorrect (do not use):**

```java
@Service
public class ProgramService {
    @Autowired
    private ProgramRepository programRepository; // Field injection - avoid
}
```

## Pitfalls

### `@NotBlank` Only Works on CharSequence

`@NotBlank` is designed for `String` and other `CharSequence` types. For `Integer` fields like `programTypeId`, use `@NotNull` instead:

```java
// Correct
@NotNull(message = "Program type is required")
private Integer programTypeId;

// Incorrect - will not work as expected
@NotBlank(message = "Program type is required")
private Integer programTypeId;
```

### H2 MODE=MSSQLServer Limitations

H2 with `MODE=MSSQLServer` does **not** support:

- `sys.tables` view
- `sys.columns` view
- Other SQL Server system views

Use `INFORMATION_SCHEMA` tables or rely on Flyway versioning instead.

### Base Package and Component Scanning

The base package (`com.ontario.program`) must be at or above the `@SpringBootApplication` class for component scanning to work correctly:

```java
// ProgramApplication.java must be in com.ontario.program
package com.ontario.program;

@SpringBootApplication
public class ProgramApplication {
    public static void main(String[] args) {
        SpringApplication.run(ProgramApplication.class, args);
    }
}
```

### Flyway with DDL Auto

Never use `ddl-auto: update` or `ddl-auto: create-drop` when Flyway is managing migrations. Always use `ddl-auto: validate` to ensure the schema matches entity definitions without Hibernate modifying the database.
