package com.ontario.program.exception;

public class ProgramNotFoundException extends RuntimeException {

    public ProgramNotFoundException(Integer id) {
        super("Program with id " + id + " not found");
    }
}
