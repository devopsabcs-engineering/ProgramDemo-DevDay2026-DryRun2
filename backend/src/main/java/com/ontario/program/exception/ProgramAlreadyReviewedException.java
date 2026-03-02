package com.ontario.program.exception;

public class ProgramAlreadyReviewedException extends RuntimeException {

    public ProgramAlreadyReviewedException(Integer id) {
        super("Program has already been reviewed and cannot be modified");
    }
}
