-- V003__create_notification_table.sql
-- AB#1891 Create notification table
-- System-generated records for tracking email notifications on status changes

IF NOT EXISTS (SELECT 1 FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_NAME = 'notification')
BEGIN
    CREATE TABLE notification (
        id INT IDENTITY(1,1) NOT NULL,
        program_id INT NOT NULL,
        notification_type NVARCHAR(50) NOT NULL,
        recipient_email NVARCHAR(200) NOT NULL,
        subject NVARCHAR(500) NOT NULL,
        body NVARCHAR(MAX) NOT NULL,
        sent_at DATETIME2 NULL,
        created_at DATETIME2 NOT NULL DEFAULT GETDATE(),
        updated_at DATETIME2 NULL,
        status NVARCHAR(20) NOT NULL DEFAULT 'PENDING',
        CONSTRAINT PK_notification PRIMARY KEY (id),
        CONSTRAINT FK_notification_program FOREIGN KEY (program_id) 
            REFERENCES program(id)
    );
END;
