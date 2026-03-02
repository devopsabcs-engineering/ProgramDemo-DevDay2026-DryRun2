package com.ontario.program.exception;

import org.springframework.http.HttpStatus;
import org.springframework.http.ProblemDetail;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;

import java.util.stream.Collectors;

@RestControllerAdvice
public class GlobalExceptionHandler {

    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ProblemDetail handleValidationException(MethodArgumentNotValidException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
        problem.setTitle("Validation Failed");
        problem.setDetail(ex.getBindingResult().getFieldErrors().stream()
                .map(e -> e.getField() + ": " + e.getDefaultMessage())
                .collect(Collectors.joining(", ")));
        return problem;
    }

    @ExceptionHandler(ProgramNotFoundException.class)
    public ProblemDetail handleProgramNotFound(ProgramNotFoundException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.NOT_FOUND);
        problem.setTitle("Not Found");
        problem.setDetail(ex.getMessage());
        return problem;
    }

    @ExceptionHandler(ProgramTypeNotFoundException.class)
    public ProblemDetail handleProgramTypeNotFound(ProgramTypeNotFoundException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.BAD_REQUEST);
        problem.setTitle("Invalid Program Type");
        problem.setDetail(ex.getMessage());
        return problem;
    }

    @ExceptionHandler(ProgramAlreadyReviewedException.class)
    public ProblemDetail handleProgramAlreadyReviewed(ProgramAlreadyReviewedException ex) {
        ProblemDetail problem = ProblemDetail.forStatus(HttpStatus.CONFLICT);
        problem.setTitle("Conflict");
        problem.setDetail(ex.getMessage());
        return problem;
    }
}
