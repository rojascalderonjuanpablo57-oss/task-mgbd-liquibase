-- liquibase formatted sql

-- changeset estudiante:DDL-004-crear-producto
-- comment: Crea la tabla producto con catálogo de artículos disponibles
CREATE TABLE producto (
    id_producto  SERIAL         PRIMARY KEY,
    nombre       VARCHAR(150)   NOT NULL,
    descripcion  TEXT,
    precio       NUMERIC(12,2)  NOT NULL CHECK (precio >= 0),
    stock        INT            NOT NULL DEFAULT 0 CHECK (stock >= 0),
    activo       BOOLEAN        NOT NULL DEFAULT TRUE
);

-- rollback DROP TABLE IF EXISTS producto;
