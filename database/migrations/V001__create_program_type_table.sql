-- V001__create_program_type_table.sql
-- AB#1889 Create program_type table
-- Lookup table for program categorization with bilingual names

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'program_type')
BEGIN
    CREATE TABLE program_type (
        id INT IDENTITY(1,1) NOT NULL,
        type_name NVARCHAR(100) NOT NULL,
        type_name_fr NVARCHAR(100) NOT NULL,
        CONSTRAINT PK_program_type PRIMARY KEY (id)
    );
END;
