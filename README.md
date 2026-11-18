# MiniStore — Outer JOINs (LEFT, RIGHT y FULL OUTER)

**Autor:** Gastón Rivarola
**Motor:** SQL Server (SSMS)

## Contenido del repositorio

| Archivo | Descripción |
|---|---|
| `schema.sql` | Crea las tablas `productos` y `ventas` y carga los datos de prueba |
| `soluciones.sql` | Consultas resueltas con LEFT, RIGHT y FULL OUTER JOIN |
| `README.md` | Respuestas y justificaciones |

## Cómo ejecutarlo

1. Crear una base de datos (por ejemplo `CREATE DATABASE ministore;`) y seleccionarla.
2. Ejecutar `schema.sql`.
3. Ejecutar las consultas de `soluciones.sql` de a una.

Resultados esperados: 1a = 11 filas, 1b = 2 filas, 2 = 1 fila, 3a = 12 filas, 3b = 3 filas.

---

## Respuestas

### 1. ¿Por qué usé LEFT JOIN en la Consulta 1 y no INNER JOIN? ¿Qué se perdería con INNER JOIN?

Usé LEFT JOIN porque la pregunta es qué productos **nunca se vendieron**, es decir, productos que no tienen ninguna fila en `ventas`. El LEFT JOIN conserva todas las filas de `productos` (la tabla de la izquierda) y completa con NULL las columnas de `ventas` cuando no hay coincidencia.

Con INNER JOIN solo se devuelven las filas que coinciden en ambas tablas. Se perderían justamente los productos que busco: el **Hub USB-C 7p (108)** y el **Parlante Bluetooth (109)**, que no tienen ventas. El resultado mostraría solo los 7 productos vendidos y no habría forma de detectar los que nunca se movieron.

### 2. ¿Por qué usé RIGHT JOIN en la Consulta 2? ¿Qué tabla está a la izquierda y cuál a la derecha?

En mi consulta, `productos` está a la **izquierda** (cláusula `FROM`) y `ventas` a la **derecha** (cláusula `RIGHT JOIN`).

Usé RIGHT JOIN porque necesito conservar **todas las ventas**, incluso las que no encuentran su producto en el catálogo. Con el filtro `WHERE p.producto_id IS NULL` quedan solo esas ventas huérfanas. En los datos aparece la **venta 10**, que tiene `producto_id = 999`, un producto que no existe en el catálogo (posible error de carga).

### 3. ¿Qué representan los valores NULL en cada resultado?

Un NULL en un JOIN externo no es un error: indica que **no hubo coincidencia** en la otra tabla.

- **Consulta 1 (`venta_id` NULL):** el producto no tiene ninguna venta asociada. Ejemplo: el producto 108, Hub USB-C 7p, aparece con `venta_id = NULL` porque nunca se vendió.
- **Consulta 2 (`producto_id` de `productos` NULL):** la venta no tiene un producto correspondiente en el catálogo. Ejemplo: la venta 10 aparece con `producto_en_catalogo = NULL` porque el `producto_id = 999` no existe en `productos`.

### 4. ¿Cuándo usaría FULL OUTER JOIN en un caso real de negocio?

Lo usaría en una **auditoría o conciliación entre dos fuentes de datos**, cuando necesito ver a la vez lo que falta de cada lado. En esta práctica detecta en una sola consulta tanto los productos sin ventas (108 y 109) como las ventas sin producto (venta 10).

Un caso real sería conciliar el stock registrado con los movimientos registrados, por ejemplo la lista de contenedores en una planilla de stock contra los que figuran en los movimientos de la terminal: así se detectan los que están en una sola de las dos y no en la otra. También sirve para validar migraciones de datos o para cruzar facturación contra entregas.
