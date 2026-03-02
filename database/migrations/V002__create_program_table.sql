-- V002__create_program_table.sql
-- AB#1890 Create program table
-- Core entity storing program approval requests submitted by citizens

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'program')
BEGIN
    CREATE TABLE program (
        id INT IDENTITY(1,1) NOT NULL,
        program_name NVARCHAR(200) NOT NULL,
        program_description NVARCHAR(MAX) NOT NULL,
        program_type_id INT NOT NULL,
        status NVARCHAR(20) NOT NULL DEFAULT 'DRAFT',
        reviewer_comments NVARCHAR(MAX) NULL,
        submitted_at DATETIME2 NULL,
        reviewed_at DATETIME2 NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NULL,
        created_by NVARCHAR(100) NULL,
        CONSTRAINT PK_program PRIMARY KEY (id),
        CONSTRAINT FK_program_program_type FOREIGN KEY (program_type_id) 
            REFERENCES program_type(id)
    );
END;
