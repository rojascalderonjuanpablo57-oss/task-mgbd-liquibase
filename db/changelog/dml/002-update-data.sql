-- liquibase formatted sql

-- changeset estudiante:DML-002-actualizar-datos
-- comment: Operaciones UPDATE de ejemplo sobre los datos de prueba

-- Actualizar el stock del Mouse después de la venta
UPDATE producto
SET stock = stock - 1
WHERE nombre = 'Mouse Inalámbrico Logitech';

-- Actualizar el teléfono de una persona
UPDATE persona
SET telefono = '3001112233'
WHERE correo = 'ana.garcia@ejemplo.com';

-- Marcar la factura como entregada
UPDATE factura
SET estado = 'entregada'
WHERE id_factura = (
    SELECT f.id_factura
    FROM factura f
    JOIN usuario u ON f.id_usuario = u.id_usuario
    WHERE u.nombre_usuario = 'lmartinez'
    ORDER BY f.id_factura DESC
    LIMIT 1
);

-- rollback UPDATE producto SET stock = stock + 1 WHERE nombre = 'Mouse Inalámbrico Logitech';
-- rollback UPDATE persona SET telefono = '3107654321' WHERE correo = 'ana.garcia@ejemplo.com';
-- rollback UPDATE factura SET estado = 'pagada' WHERE estado = 'entregada';
