package com.ontario.program.repository;

import com.ontario.program.model.Program;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ProgramRepository extends JpaRepository<Program, Integer> {

    List<Program> findByStatus(String status);

    @Query("SELECT p FROM Program p WHERE " +
           "LOWER(p.programName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(p.programDescription) LIKE LOWER(CONCAT('%', :search, '%'))")
    List<Program> searchByNameOrDescription(@Param("search") String search);

    @Query("SELECT p FROM Program p WHERE p.status = :status AND " +
           "(LOWER(p.programName) LIKE LOWER(CONCAT('%', :search, '%')) OR " +
           "LOWER(p.programDescription) LIKE LOWER(CONCAT('%', :search, '%')))")
    List<Program> findByStatusAndSearch(@Param("status") String status, @Param("search") String search);
}
