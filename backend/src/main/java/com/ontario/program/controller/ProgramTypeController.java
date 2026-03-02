package com.ontario.program.controller;

import com.ontario.program.dto.ProgramTypeResponse;
import com.ontario.program.service.ProgramService;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/program-types")
@CrossOrigin(origins = "*")
public class ProgramTypeController {

    private final ProgramService programService;

    public ProgramTypeController(ProgramService programService) {
        this.programService = programService;
    }

    /**
     * GET /api/program-types - Get all program types for dropdown population
     */
    @GetMapping
    public ResponseEntity<List<ProgramTypeResponse>> getProgramTypes() {
        List<ProgramTypeResponse> programTypes = programService.getProgramTypes();
        return ResponseEntity.ok(programTypes);
    }
}
