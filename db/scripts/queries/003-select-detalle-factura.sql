-- ============================================================
-- CONSULTA 003: Detalle completo de todas las facturas
-- Valida que detalle_factura relaciona correctamente factura
-- y producto, y que los cálculos de subtotal son coherentes.
-- ============================================================

SELECT
    f.id_factura,
    f.fecha_emision,
    f.estado,
    pr.nombre            AS producto,
    df.cantidad,
    df.precio_unitario,
    df.subtotal,
    f.total              AS total_factura,
    p.nombre || ' ' || p.apellido AS cliente
FROM detalle_factura df
JOIN factura  f  ON df.id_factura  = f.id_factura
JOIN producto pr ON df.id_producto = pr.id_producto
JOIN usuario  u  ON f.id_usuario   = u.id_usuario
JOIN persona  p  ON u.id_persona   = p.id_persona
ORDER BY f.id_factura, df.id_detalle;
