
-- MiniStore — Soluciones con Outer JOINs
-- Autor: [GASTON RIVAROLA]
-- Fecha: [18/11/2026]
-- ══════════════════════════════════════════
-- ── CONSULTA 1: LEFT JOIN ─────────────────
-- Pregunta de negocio: ¿Qué productos del catálogo nunca fueron vendidos?
-- Mostrá todos los productos y sus ventas asociadas.
-- Los productos sin ventas aparecerán con NULL en las columnas de ventas.

-- 1a: todos los productos con sus ventas (11 filas)
SELECT p.producto_id, p.nombre, v.venta_id
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id;

-- 1b: solo los productos nunca vendidos (2 filas)
SELECT p.producto_id, p.nombre, v.venta_id
FROM productos p
LEFT JOIN ventas v ON p.producto_id = v.producto_id
WHERE v.venta_id IS NULL;

-- ── CONSULTA 2: RIGHT JOIN ────────────────
-- Pregunta de negocio: ¿Existen ventas registradas con productos
-- que no figuran en nuestro catálogo? (posible error de carga de datos)
-- Los registros huérfanos aparecerán con NULL en las columnas de productos.

SELECT v.venta_id, v.producto_id, p.producto_id AS producto_en_catalogo
FROM productos p
RIGHT JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL;

-- ── CONSULTA 3: FULL OUTER JOIN ───────────
-- Pregunta de negocio: Vista completa de auditoría que muestre
-- todos los productos y todas las ventas sin perder ninguna fila,
-- identificando tanto productos sin ventas como ventas sin producto.

-- 3a: vista completa de ambas tablas (12 filas)
SELECT p.producto_id, p.nombre, v.venta_id, v.producto_id AS producto_en_venta
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id;

-- 3b: solo los casos con problema (3 filas)
SELECT p.producto_id, p.nombre, v.venta_id, v.producto_id AS producto_en_venta
FROM productos p
FULL OUTER JOIN ventas v ON p.producto_id = v.producto_id
WHERE p.producto_id IS NULL OR v.venta_id IS NULL;
