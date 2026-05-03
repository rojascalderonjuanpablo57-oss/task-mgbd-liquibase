-- ============================================================
-- CONSULTA 002: Listar facturas con el nombre del cliente
-- Valida que la tabla factura está correctamente relacionada
-- con usuario y persona.
-- ============================================================

SELECT
    f.id_factura,
    f.fecha_emision,
    f.estado,
    f.total,
    p.nombre || ' ' || p.apellido  AS cliente,
    u.nombre_usuario
FROM factura f
JOIN usuario u ON f.id_usuario = u.id_usuario
JOIN persona p ON u.id_persona = p.id_persona
ORDER BY f.fecha_emision DESC;
