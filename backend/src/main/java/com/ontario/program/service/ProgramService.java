package com.ontario.program.service;

import com.ontario.program.dto.*;
import com.ontario.program.exception.ProgramAlreadyReviewedException;
import com.ontario.program.exception.ProgramNotFoundException;
import com.ontario.program.exception.ProgramTypeNotFoundException;
import com.ontario.program.model.Program;
import com.ontario.program.model.ProgramType;
import com.ontario.program.repository.ProgramRepository;
import com.ontario.program.repository.ProgramTypeRepository;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class ProgramService {

    private final ProgramRepository programRepository;
    private final ProgramTypeRepository programTypeRepository;

    public ProgramService(ProgramRepository programRepository,
                          ProgramTypeRepository programTypeRepository) {
        this.programRepository = programRepository;
        this.programTypeRepository = programTypeRepository;
    }

    @Transactional
    public ProgramResponse submitProgram(ProgramSubmitRequest request) {
        ProgramType programType = programTypeRepository.findById(request.programTypeId())
                .orElseThrow(() -> new ProgramTypeNotFoundException(request.programTypeId()));

        Program program = new Program();
        program.setProgramName(request.programName());
        program.setProgramDescription(request.programDescription());
        program.setProgramType(programType);
        program.setStatus("SUBMITTED");
        program.setSubmittedAt(LocalDateTime.now());
        program.setCreatedBy(request.createdBy());

        Program saved = programRepository.save(program);
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<ProgramResponse> getPrograms(String status, String search) {
        List<Program> programs;

        if (status != null && search != null) {
            programs = programRepository.findByStatusAndSearch(status, search);
        } else if (status != null) {
            programs = programRepository.findByStatus(status);
        } else if (search != null) {
            programs = programRepository.searchByNameOrDescription(search);
        } else {
            programs = programRepository.findAll();
        }

        return programs.stream()
                .map(this::toResponse)
                .toList();
    }

    @Transactional(readOnly = true)
    public ProgramResponse getProgram(Integer id) {
        Program program = programRepository.findById(id)
                .orElseThrow(() -> new ProgramNotFoundException(id));
        return toResponse(program);
    }

    @Transactional
    public ProgramResponse reviewProgram(Integer id, ProgramReviewRequest request) {
        Program program = programRepository.findById(id)
                .orElseThrow(() -> new ProgramNotFoundException(id));

        if (!"SUBMITTED".equals(program.getStatus())) {
            throw new ProgramAlreadyReviewedException(id);
        }

        program.setStatus(request.status());
        program.setReviewerComments(request.reviewerComments());
        program.setReviewedAt(LocalDateTime.now());

        Program saved = programRepository.save(program);
        return toResponse(saved);
    }

    @Transactional(readOnly = true)
    public List<ProgramTypeResponse> getProgramTypes() {
        return programTypeRepository.findAll().stream()
                .map(pt -> new ProgramTypeResponse(
                        pt.getId(),
                        pt.getTypeName(),
                        pt.getTypeNameFr()))
                .toList();
    }

    private ProgramResponse toResponse(Program program) {
        ProgramType pt = program.getProgramType();
        return new ProgramResponse(
                program.getId(),
                program.getProgramName(),
                program.getProgramDescription(),
                pt.getId(),
                pt.getTypeName(),
                pt.getTypeNameFr(),
                program.getStatus(),
                program.getReviewerComments(),
                program.getSubmittedAt(),
                program.getReviewedAt(),
                program.getCreatedAt(),
                program.getUpdatedAt(),
                program.getCreatedBy()
        );
    }
}
