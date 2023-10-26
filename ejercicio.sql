CREATE TABLE productos (
codigo INTEGER PRIMARY KEY,
descripcion VARCHAR(255),
precio DECIMAL(10,2),
categoria VARCHAR(255)
);
 
CREATE TABLE ventas (
codigo_producto INTEGER,
cantidad INTEGER,
precio_total DECIMAL(10,2),
fecha DATETIME,
vendedor VARCHAR(255)
);

INSERT INTO productos (codigo, descripcion, precio, categoria) VALUES
(1, 'Celular', 1000, 'Electrónica'),
(2, 'Televisión', 5000, 'Electrónica'),
(3, 'Laptop', 3000, 'Electrónica'),
(4, 'Camiseta', 50, 'Ropa'),
(5, 'Pantalon', 100, 'Ropa'),
(6, 'Zapatos', 200, 'Ropa');

INSERT INTO ventas (codigo_producto, cantidad, precio_total, fecha, vendedor) VALUES
(1, 10, 10000, '2023-07-01', 'Juan'),
(2, 5, 25000, '2023-07-02', 'Pedro'),
(3, 2, 6000, '2023-07-03', 'Maria'),
(4, 10, 500, '2023-07-04', 'Ana'),
(5, 5, 500, '2023-07-05', 'Pablo'),
(6, 2, 400, '2023-07-06', 'Luis');


INSERT INTO ventas (codigo_producto, cantidad, precio_total, fecha, vendedor) VALUES 
(2, 15, 75000, '2023-07-02', 'Maria')
(5, 5, 10000, '2023-09-01', 'Juan')



-- Listar todos los productos disponibles, junto con su descripción, precio y categoría.
SELECT * FROM productos;

-- Listar todas las ventas realizadas, junto con el código del producto, la cantidad vendida, el precio total de la venta y la fecha de la venta.
SELECT * FROM ventas;




-- Listar el producto más vendido, junto con la cantidad vendida.
SELECT p.codigo as cod_producto, p.descripcion, p.precio, p.categoria, SUM(v.cantidad) as cantidad_vendida -- DETALLES CANT TOTAL VENDIDA
FROM productos p 
JOIN ventas v ON p.codigo = v.codigo_producto -- SE UNEN LA TABLAS
GROUP BY p.codigo
HAVING SUM(v.cantidad) = (                    
  SELECT SUM(cantidad) as cantidad_maxima  -- having filtra x los resultados del group by 
  FROM ventas                               -- select sum, calcula la cantidad total vendida de cada producto
  GROUP BY codigo_producto
  ORDER BY cantidad_maxima DESC
  LIMIT 1
);
-- Listar el producto menos vendido, junto con la cantidad vendida.
SELECT p.codigo as cod_producto, p.descripcion, p.precio, p.categoria, SUM(v.cantidad) as cantidad_vendida
FROM productos p
JOIN ventas v ON p.codigo = v.codigo_producto
GROUP BY p.codigo
HAVING SUM(v.cantidad) = (
  SELECT SUM(cantidad) as cantidad_min
  FROM ventas
  GROUP BY codigo_producto
  ORDER BY cantidad_min 
  LIMIT 1
);




-- Listar el total de ventas realizadas por cada producto.
SELECT p.descripcion as producto, COUNT(v.codigo_producto) as total_ventas
FROM productos p
JOIN ventas v on p.codigo = v.codigo_producto
GROUP BY p.descripcion

-- Listar todos los productos que cuestan más de $100.
SELECT * FROM productos WHERE precio > 100;

-- Listar todas las ventas realizadas en el mes de julio de 2023.
SELECT * FROM ventas WHERE fecha LIKE '2023-07-%';




-- Listar el producto más vendido por cada categoría de producto.
SELECT p.categoria, p.descripcion, p.precio, p.codigo, SUM(v.cantidad) as cantidad_total
FROM productos p
JOIN ventas v ON p.codigo = v.codigo_producto
GROUP BY p.codigo  -- having selecciona los prod q la cantidad vendida sea igual a la cantidad maxima vendida en la categoria
HAVING (p.categoria, SUM(v.cantidad)) IN ( 
    SELECT categoria, MAX(cantidad_total) -- calcula la cantidad total vendida para cada producto y selecciona la cant max para cada categoria
    FROM (
        SELECT p.categoria, SUM(v.cantidad) as cantidad_total  
        FROM productos p
        JOIN ventas v ON p.codigo = v.codigo_producto
        GROUP BY p.codigo
    ) as subquery  -- calcula la cantidad total vendida para cada producto
    GROUP BY categoria 
);




-- Listar el total de ventas realizadas por cada vendedor.
SELECT vendedor, COUNT(vendedor) AS total_ventas
FROM ventas
GROUP BY vendedor