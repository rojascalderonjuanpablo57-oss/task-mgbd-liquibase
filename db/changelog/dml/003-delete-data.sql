-- liquibase formatted sql

-- changeset estudiante:DML-003-eliminar-datos
-- comment: Operaciones DELETE de ejemplo (desactivar registros de forma segura)

-- Desactivar el rol 'cliente' temporalmente (borrado lógico, no físico)
UPDATE rol
SET activo = FALSE
WHERE nombre = 'cliente';

-- Desactivar el producto que ya no tiene stock suficiente
UPDATE producto
SET activo = FALSE
WHERE nombre = 'Laptop Lenovo IdeaPad'
  AND stock < 2;

-- rollback UPDATE rol SET activo = TRUE WHERE nombre = 'cliente';
-- rollback UPDATE producto SET activo = TRUE WHERE nombre = 'Laptop Lenovo IdeaPad';
