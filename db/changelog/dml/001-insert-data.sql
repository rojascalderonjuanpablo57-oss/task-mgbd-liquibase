-- liquibase formatted sql

-- changeset estudiante:DML-001-insertar-datos
-- comment: Inserta datos de prueba en todas las tablas del sistema

-- Roles del sistema
INSERT INTO rol (nombre, descripcion, activo) VALUES
    ('administrador', 'Acceso total al sistema',                          TRUE),
    ('vendedor',      'Puede crear facturas y gestionar productos',        TRUE),
    ('cliente',       'Puede realizar compras y consultar sus facturas',   TRUE);

-- Personas (datos personales)
INSERT INTO persona (nombre, apellido, correo, telefono, fecha_nacimiento) VALUES
    ('Carlos',  'Pérez',    'carlos.perez@ejemplo.com',  '3001234567', '1990-05-15'),
    ('Ana',     'García',   'ana.garcia@ejemplo.com',    '3107654321', '1995-08-22'),
    ('Luis',    'Martínez', 'luis.martinez@ejemplo.com', '3209876543', '1988-11-30');

-- Usuarios vinculados a persona y rol
INSERT INTO usuario (nombre_usuario, contrasena_hash, activo, id_persona, id_rol) VALUES
    ('cperez',    '$2b$10$HASH_EJEMPLO_ADMIN_001',    TRUE,
        (SELECT id_persona FROM persona WHERE correo = 'carlos.perez@ejemplo.com'),
        (SELECT id_rol     FROM rol     WHERE nombre  = 'administrador')),
    ('agarcia',   '$2b$10$HASH_EJEMPLO_VENDEDOR_002', TRUE,
        (SELECT id_persona FROM persona WHERE correo = 'ana.garcia@ejemplo.com'),
        (SELECT id_rol     FROM rol     WHERE nombre  = 'vendedor')),
    ('lmartinez', '$2b$10$HASH_EJEMPLO_CLIENTE_003',  TRUE,
        (SELECT id_persona FROM persona WHERE correo = 'luis.martinez@ejemplo.com'),
        (SELECT id_rol     FROM rol     WHERE nombre  = 'cliente'));

-- Productos del catálogo
INSERT INTO producto (nombre, descripcion, precio, stock) VALUES
    ('Laptop Lenovo IdeaPad',    'Portátil 15.6 pulg., 8 GB RAM, 256 GB SSD', 2500000.00, 10),
    ('Mouse Inalámbrico Logitech','Mouse ergonómico con receptor USB',           85000.00, 50),
    ('Teclado Mecánico Redragon','Teclado gaming con retroiluminación RGB',     220000.00, 25);

-- Factura de ejemplo del cliente lmartinez
INSERT INTO factura (total, estado, id_usuario) VALUES
    (2585000.00, 'pagada',
        (SELECT id_usuario FROM usuario WHERE nombre_usuario = 'lmartinez'));

-- Detalles de la factura anterior
INSERT INTO detalle_factura (cantidad, precio_unitario, subtotal, id_factura, id_producto) VALUES
    (1, 2500000.00, 2500000.00,
        (SELECT id_factura FROM factura ORDER BY id_factura DESC LIMIT 1),
        (SELECT id_producto FROM producto WHERE nombre = 'Laptop Lenovo IdeaPad')),
    (1, 85000.00, 85000.00,
        (SELECT id_factura FROM factura ORDER BY id_factura DESC LIMIT 1),
        (SELECT id_producto FROM producto WHERE nombre = 'Mouse Inalámbrico Logitech'));

-- rollback DELETE FROM detalle_factura; DELETE FROM factura; DELETE FROM producto; DELETE FROM usuario; DELETE FROM persona; DELETE FROM rol;
