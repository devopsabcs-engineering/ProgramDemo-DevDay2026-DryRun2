package com.ontario.program.controller;

import com.ontario.program.dto.*;
import com.ontario.program.service.ProgramService;
import jakarta.validation.Valid;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/programs")
@CrossOrigin(origins = "*")
public class ProgramController {

    private final ProgramService programService;

    public ProgramController(ProgramService programService) {
        this.programService = programService;
    }

    /**
     * POST /api/programs - Submit a new program for approval
     */
    @PostMapping
    public ResponseEntity<ProgramResponse> submitProgram(
            @Valid @RequestBody ProgramSubmitRequest request) {
        ProgramResponse response = programService.submitProgram(request);
        return ResponseEntity.status(HttpStatus.CREATED).body(response);
    }

    /**
     * GET /api/programs - List all programs with optional filtering
     */
    @GetMapping
    public ResponseEntity<List<ProgramResponse>> getPrograms(
            @RequestParam(required = false) String status,
            @RequestParam(required = false) String search) {
        List<ProgramResponse> programs = programService.getPrograms(status, search);
        return ResponseEntity.ok(programs);
    }

    /**
     * GET /api/programs/{id} - Get a single program by ID
     */
    @GetMapping("/{id}")
    public ResponseEntity<ProgramResponse> getProgram(@PathVariable Integer id) {
        ProgramResponse program = programService.getProgram(id);
        return ResponseEntity.ok(program);
    }

    /**
     * PUT /api/programs/{id}/review - Approve or reject a program
     */
    @PutMapping("/{id}/review")
    public ResponseEntity<ProgramResponse> reviewProgram(
            @PathVariable Integer id,
            @Valid @RequestBody ProgramReviewRequest request) {
        ProgramResponse response = programService.reviewProgram(id, request);
        return ResponseEntity.ok(response);
    }
}
