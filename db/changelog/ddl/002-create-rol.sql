-- liquibase formatted sql

-- changeset estudiante:DDL-002-crear-rol
-- comment: Crea la tabla rol para definir permisos de acceso al sistema
CREATE TABLE rol (
    id_rol      SERIAL        PRIMARY KEY,
    nombre      VARCHAR(50)   NOT NULL UNIQUE,
    descripcion VARCHAR(255),
    activo      BOOLEAN       NOT NULL DEFAULT TRUE
);

-- rollback DROP TABLE IF EXISTS rol;
