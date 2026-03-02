package com.ontario.program.repository;

import com.ontario.program.model.ProgramType;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ProgramTypeRepository extends JpaRepository<ProgramType, Integer> {
}
