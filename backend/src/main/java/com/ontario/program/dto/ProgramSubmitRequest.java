package com.ontario.program.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;

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
