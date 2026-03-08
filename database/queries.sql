-- inventory report
SELECT
  inventoryitem.name,
  inventoryitem.sku,
  inventoryitem.quantity_on_hand,
  inventoryitem.unit_price,
  supplier.name AS supplier_name,
  warehouse.code AS warehouse_code
FROM
  inventoryitem
  JOIN supplier ON inventoryitem.supplier_id = supplier.id
  JOIN warehouse ON inventoryitem.warehouse_id = warehouse.id;

-- employees working in warehouse
SELECT
  person.first_name,
  person.last_name,
  employee.role,
  warehouse.code
FROM
  employee
  JOIN person ON employee.person_id = person.id
  JOIN warehouse ON employee.warehouse_id = warehouse.id;

-- storage locations in the warehouse
SELECT
  warehouse.code,
  storagelocation.aisle,
  storagelocation.shelf,
  storagelocation.bin
FROM
  storagelocation
  JOIN warehouse ON storagelocation.warehouse_id = warehouse.id;

-- items supplied by tech supplies inc.
SELECT
  inventoryitem.name,
  inventoryitem.sku,
  inventoryitem.quantity_on_hand
FROM
  inventoryitem
  JOIN supplier ON inventoryitem.supplier_id = supplier.id
WHERE
  supplier.name = 'Tech Supplies Inc';

-- sales history
SELECT
  sale.id,
  person.first_name,
  person.last_name,
  sale.date,
  sale.total
FROM
  sale
  JOIN person ON sale.customer_id = person.id;

-- details of the sale item
SELECT
  saleitem.sale_id,
  inventoryitem.name,
  saleitem.quantity,
  saleitem.price
FROM
  saleitem
  JOIN inventoryitem ON saleitem.item_id = inventoryitem.id;

-- refund report
SELECT
  refund.id,
  refund.date,
  refund.total,
  sale.id AS sale_id
FROM
  refund
  JOIN sale ON refund.sale_id = sale.id;

-- low stock items
SELECT
  name,
  sku,
  quantity_on_hand
FROM
  inventoryitem
WHERE
  quantity_on_hand < 50;

-- total inventory
SELECT
  SUM(quantity_on_hand * unit_price) AS total_inventory_value
FROM
  inventoryitem;

-- sales by customer with totals
SELECT
  person.first_name,
  person.last_name,
  COUNT(sale.id) AS total_orders,
  SUM(sale.total) AS lifetime_value
FROM
  person
  JOIN sale ON person.id = sale.customer_id
GROUP BY
  person.id,
  person.first_name,
  person.last_name;

-- inventory value by warehouse
SELECT
  warehouse.code,
  COUNT(inventoryitem.id) AS item_count,
  SUM(
    inventoryitem.quantity_on_hand * inventoryitem.unit_price
  ) AS warehouse_value
FROM
  warehouse
  LEFT JOIN inventoryitem ON warehouse.id = inventoryitem.warehouse_id
GROUP BY
  warehouse.id,
  warehouse.code;

-- complete order fulfillment view
SELECT
  sale.id AS sale_id,
  person.first_name || ' ' || person.last_name AS customer,
  inventoryitem.name AS product,
  saleitem.quantity,
  warehouse.code AS fulfilled_from,
  storagelocation.aisle || '-' || storagelocation.shelf || '-' || storagelocation.bin AS location,
  employee.role AS processed_by_role
FROM
  sale
  JOIN person ON sale.customer_id = person.id
  JOIN saleitem ON sale.id = saleitem.sale_id
  JOIN inventoryitem ON saleitem.item_id = inventoryitem.id
  JOIN warehouse ON inventoryitem.warehouse_id = warehouse.id
  JOIN storagelocation ON inventoryitem.storage_location_id = storagelocation.id
  LEFT JOIN employee ON warehouse.id = employee.warehouse_id
WHERE
  sale.date > NOW () - INTERVAL '30 days';
