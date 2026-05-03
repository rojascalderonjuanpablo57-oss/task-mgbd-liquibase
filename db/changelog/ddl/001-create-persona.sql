-- liquibase formatted sql

-- changeset estudiante:DDL-001-crear-persona
-- comment: Crea la tabla persona con datos personales básicos
CREATE TABLE persona (
    id_persona   SERIAL         PRIMARY KEY,
    nombre       VARCHAR(100)   NOT NULL,
    apellido     VARCHAR(100)   NOT NULL,
    correo       VARCHAR(150)   NOT NULL UNIQUE,
    telefono     VARCHAR(20),
    fecha_nacimiento DATE
);

-- rollback DROP TABLE IF EXISTS persona;
