---
description: "Azure SQL and Flyway migration conventions for the database layer"
applyTo: 'database/**'
---

# SQL Conventions

This document defines the Azure SQL and Flyway migration conventions for the database layer.

## Conventions

| Area | Convention |
|------|-----------|
| Target | Azure SQL (H2 locally with `MODE=MSSQLServer`) |
| Migrations | Flyway versioned: `V001__description.sql` |
| Text columns | `NVARCHAR` (Unicode for EN/FR) |
| Primary keys | `INT IDENTITY(1,1)` |
| Timestamps | `DATETIME2` |
| DDL guards | `IF NOT EXISTS` on CREATE TABLE and ALTER TABLE |
| Seed data | `INSERT ... WHERE NOT EXISTS` (never MERGE) |
| Audit columns | `created_at`, `updated_at`, `created_by` where applicable |
| Naming | `PK_tablename`, `FK_tablename_reference` |
| Rule | One logical change per migration file; never modify applied migrations |

## Migration File Naming

```text
V001__create_program_types_table.sql
V002__create_programs_table.sql
V003__seed_program_types.sql
V004__add_program_status_column.sql
```

- **V** prefix indicates versioned migration
- **001** three-digit version number
- **__** double underscore separator
- **description** lowercase with underscores

## Example: Create Table Migration

```sql
-- V001__create_program_types_table.sql
IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'program_types')
BEGIN
    CREATE TABLE program_types (
        id INT IDENTITY(1,1) NOT NULL,
        name_en NVARCHAR(100) NOT NULL,
        name_fr NVARCHAR(100) NOT NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NULL,
        CONSTRAINT PK_program_types PRIMARY KEY (id)
    );
END;
```

## Example: Seed Data Migration

```sql
-- V003__seed_program_types.sql
INSERT INTO program_types (name_en, name_fr)
SELECT 'Grant', N'Subvention'
WHERE NOT EXISTS (SELECT 1 FROM program_types WHERE name_en = 'Grant');

INSERT INTO program_types (name_en, name_fr)
SELECT 'Loan', N'Prêt'
WHERE NOT EXISTS (SELECT 1 FROM program_types WHERE name_en = 'Loan');

INSERT INTO program_types (name_en, name_fr)
SELECT 'Tax Credit', N'Crédit d''impôt'
WHERE NOT EXISTS (SELECT 1 FROM program_types WHERE name_en = 'Tax Credit');
```

## Why Avoid MERGE

SQL Server `MERGE` statement has documented concurrency bugs that can cause data corruption under load. Microsoft has acknowledged these issues in multiple KB articles.

**Do not use:**

```sql
-- AVOID: MERGE has concurrency bugs
MERGE INTO program_types AS target
USING (VALUES ('Grant', N'Subvention')) AS source (name_en, name_fr)
ON target.name_en = source.name_en
WHEN NOT MATCHED THEN INSERT (name_en, name_fr) VALUES (source.name_en, source.name_fr);
```

**Use instead:**

```sql
-- SAFE: INSERT ... WHERE NOT EXISTS is idempotent and bug-free
INSERT INTO program_types (name_en, name_fr)
SELECT 'Grant', N'Subvention'
WHERE NOT EXISTS (SELECT 1 FROM program_types WHERE name_en = 'Grant');
```

The `INSERT ... WHERE NOT EXISTS` pattern is:

- Idempotent (safe to run multiple times)
- Free of concurrency bugs
- Works identically on H2 and Azure SQL

## H2 Compatibility Notes

H2 with `MODE=MSSQLServer` supports:

| Feature | Supported |
|---------|-----------|
| `IDENTITY(1,1)` | ✅ Yes |
| `NVARCHAR` | ✅ Yes |
| `DATETIME2` | ✅ Yes |
| `GETDATE()` | ✅ Yes |
| `IF NOT EXISTS` guards | ✅ Yes |
| `sys.tables` view | ❌ No |
| `sys.columns` view | ❌ No |

For schema introspection, use `INFORMATION_SCHEMA` tables instead of SQL Server system views:

```sql
-- Works on both H2 and Azure SQL
SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE = 'BASE TABLE';

-- Does NOT work on H2
SELECT name FROM sys.tables;
```

## Foreign Key Naming

```sql
CONSTRAINT FK_programs_program_types FOREIGN KEY (program_type_id) REFERENCES program_types(id)
```

Format: `FK_{child_table}_{parent_table}`

## Audit Columns

Include audit columns where applicable:

```sql
created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
updated_at DATETIME2 NULL,
created_by NVARCHAR(100) NULL
```

Update `updated_at` in application code or via triggers when records are modified.

## Migration Rules

1. **One logical change per file:** Each migration should do one thing (create table, add column, seed data)
2. **Never modify applied migrations:** Once a migration has been applied to any environment, never change it
3. **Always use DDL guards:** `IF NOT EXISTS` prevents failures on re-run
4. **Test locally first:** Run migrations against H2 before deploying to Azure SQL
5. **Version sequentially:** Never skip version numbers or reuse them
