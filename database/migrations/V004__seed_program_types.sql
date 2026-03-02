-- V004__seed_program_types.sql
-- AB#1892 Insert seed data
-- Pre-populate program_type with 5 bilingual categories

INSERT INTO program_type (type_name, type_name_fr)
SELECT N'Community Services', N'Services communautaires'
WHERE NOT EXISTS (
    SELECT 1 FROM program_type WHERE type_name = N'Community Services'
);

INSERT INTO program_type (type_name, type_name_fr)
SELECT N'Health & Wellness', N'Santé et bien-être'
WHERE NOT EXISTS (
    SELECT 1 FROM program_type WHERE type_name = N'Health & Wellness'
);

INSERT INTO program_type (type_name, type_name_fr)
SELECT N'Education & Training', N'Éducation et formation'
WHERE NOT EXISTS (
    SELECT 1 FROM program_type WHERE type_name = N'Education & Training'
);

INSERT INTO program_type (type_name, type_name_fr)
SELECT N'Environment & Conservation', N'Environnement et conservation'
WHERE NOT EXISTS (
    SELECT 1 FROM program_type WHERE type_name = N'Environment & Conservation'
);

INSERT INTO program_type (type_name, type_name_fr)
SELECT N'Economic Development', N'Développement économique'
WHERE NOT EXISTS (
    SELECT 1 FROM program_type WHERE type_name = N'Economic Development'
);
