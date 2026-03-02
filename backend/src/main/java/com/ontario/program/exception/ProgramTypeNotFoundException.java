package com.ontario.program.exception;

public class ProgramTypeNotFoundException extends RuntimeException {

    public ProgramTypeNotFoundException(Integer id) {
        super("Program type with id " + id + " not found");
    }
}
