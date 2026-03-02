package com.ontario.program.model;

import jakarta.persistence.*;

@Entity
@Table(name = "program_type")
public class ProgramType {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "type_name", nullable = false, length = 100)
    private String typeName;

    @Column(name = "type_name_fr", nullable = false, length = 100)
    private String typeNameFr;

    public ProgramType() {
    }

    public ProgramType(String typeName, String typeNameFr) {
        this.typeName = typeName;
        this.typeNameFr = typeNameFr;
    }

    public Integer getId() {
        return id;
    }

    public void setId(Integer id) {
        this.id = id;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getTypeNameFr() {
        return typeNameFr;
    }

    public void setTypeNameFr(String typeNameFr) {
        this.typeNameFr = typeNameFr;
    }
}
