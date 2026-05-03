-- liquibase formatted sql

-- changeset estudiante:DDL-006-crear-detalle-factura
-- comment: Crea la tabla detalle_factura con las líneas de cada factura
CREATE TABLE detalle_factura (
    id_detalle      SERIAL         PRIMARY KEY,
    cantidad        INT            NOT NULL CHECK (cantidad > 0),
    precio_unitario NUMERIC(12,2)  NOT NULL CHECK (precio_unitario >= 0),
    subtotal        NUMERIC(14,2)  NOT NULL CHECK (subtotal >= 0),
    -- Pertenece a una factura
    id_factura      INT            NOT NULL,
    -- Referencia al producto comprado
    id_producto     INT            NOT NULL,
    CONSTRAINT fk_detalle_factura
        FOREIGN KEY (id_factura)  REFERENCES factura(id_factura)  ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (id_producto) REFERENCES producto(id_producto) ON DELETE RESTRICT
);

-- rollback DROP TABLE IF EXISTS detalle_factura;
