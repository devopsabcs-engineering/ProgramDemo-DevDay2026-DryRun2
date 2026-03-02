package com.ontario.program.dto;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;

public record ProgramReviewRequest(
    @NotBlank(message = "Status is required")
    @Pattern(regexp = "APPROVED|REJECTED", message = "Status must be APPROVED or REJECTED")
    String status,

    String reviewerComments
) {}
