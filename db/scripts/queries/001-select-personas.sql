-- ============================================================
-- CONSULTA 001: Listar personas con su usuario y rol
-- Valida que las tablas persona, usuario y rol están pobladas
-- y que las llaves foráneas funcionan correctamente.
-- ============================================================

SELECT
    p.id_persona,
    p.nombre || ' ' || p.apellido  AS nombre_completo,
    p.correo,
    p.telefono,
    u.nombre_usuario,
    r.nombre                        AS rol,
    u.activo
FROM persona p
JOIN usuario u ON u.id_persona = p.id_persona
JOIN rol     r ON u.id_rol     = r.id_rol
ORDER BY p.id_persona;
