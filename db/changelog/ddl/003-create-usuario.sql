-- liquibase formatted sql

-- changeset estudiante:DDL-003-crear-usuario
-- comment: Crea la tabla usuario que vincula persona y rol para el acceso al sistema
CREATE TABLE usuario (
    id_usuario      SERIAL       PRIMARY KEY,
    nombre_usuario  VARCHAR(80)  NOT NULL UNIQUE,
    contrasena_hash VARCHAR(255) NOT NULL,
    activo          BOOLEAN      NOT NULL DEFAULT TRUE,
    fecha_creacion  TIMESTAMP    NOT NULL DEFAULT NOW(),
    -- Relación con persona (datos personales)
    id_persona      INT          NOT NULL,
    -- Relación con rol (permisos)
    id_rol          INT          NOT NULL,
    CONSTRAINT fk_usuario_persona
        FOREIGN KEY (id_persona) REFERENCES persona(id_persona) ON DELETE RESTRICT,
    CONSTRAINT fk_usuario_rol
        FOREIGN KEY (id_rol)     REFERENCES rol(id_rol)         ON DELETE RESTRICT
);

-- rollback DROP TABLE IF EXISTS usuario;
