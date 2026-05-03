-- liquibase formatted sql

-- changeset estudiante:DDL-005-crear-factura
-- comment: Crea la tabla factura que registra cada transacción de venta
CREATE TABLE factura (
    id_factura    SERIAL         PRIMARY KEY,
    fecha_emision TIMESTAMP      NOT NULL DEFAULT NOW(),
    total         NUMERIC(14,2)  NOT NULL DEFAULT 0,
    estado        VARCHAR(30)    NOT NULL DEFAULT 'pendiente',
    -- El usuario que realizó la compra
    id_usuario    INT            NOT NULL,
    CONSTRAINT fk_factura_usuario
        FOREIGN KEY (id_usuario) REFERENCES usuario(id_usuario) ON DELETE RESTRICT
);

-- rollback DROP TABLE IF EXISTS factura;
