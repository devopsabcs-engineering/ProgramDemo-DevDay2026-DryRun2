package com.ontario.program.dto;

import java.time.LocalDateTime;

public record ProgramResponse(
    Integer id,
    String programName,
    String programDescription,
    Integer programTypeId,
    String programTypeName,
    String programTypeNameFr,
    String status,
    String reviewerComments,
    LocalDateTime submittedAt,
    LocalDateTime reviewedAt,
    LocalDateTime createdAt,
    LocalDateTime updatedAt,
    String createdBy
) {}
