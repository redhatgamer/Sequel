-- inventory report
SELECT
    inventoryitem.name,
    inventoryitem.sku,
    inventoryitem.quantity_on_hand,
    inventoryitem.unit_price,
    supplier.name AS supplier_name,
    warehouse.code AS warehouse_code
FROM inventoryitem
JOIN supplier ON inventoryitem.supplier_id = supplier.id
JOIN warehouse ON inventoryitem.warehouse_id = warehouse.id;



-- employees working in warehouse
SELECT
    person.first_name,
    person.last_name,
    employee.role,
    warehouse.code
FROM employee
JOIN person ON employee.person_id = person.id
JOIN warehouse ON employee.warehouse_id = warehouse.id;


-- storage locations in the warehouse
SELECT
    warehouse.code,
    storagelocation.aisle,
    storagelocation.shelf,
    storagelocation.bin
FROM storagelocation
JOIN warehouse ON storagelocation.warehouse_id = warehouse.id;


-- items supplied by tech supplies inc.
SELECT
    inventoryitem.name,
    inventoryitem.sku,
    inventoryitem.quantity_on_hand
FROM inventoryitem
JOIN supplier ON inventoryitem.supplier_id = supplier.id
WHERE supplier.name = 'Tech Supplies Inc';


-- sales history
SELECT
    sale.id,
    person.first_name,
    person.last_name,
    sale.date,
    sale.total
FROM sale
JOIN person ON sale.customer_id = person.id;


-- details of the sale item
SELECT
    saleitem.sale_id,
    inventoryitem.name,
    saleitem.quantity,
    saleitem.price
FROM saleitem
JOIN inventoryitem ON saleitem.item_id = inventoryitem.id;


-- refund report
SELECT
    refund.id,
    refund.date,
    refund.total,
    sale.id AS sale_id
FROM refund
JOIN sale ON refund.sale_id = sale.id;



-- low stock items
SELECT
    name,
    sku,
    quantity_on_hand
FROM inventoryitem
WHERE quantity_on_hand < 50;


-- total inventory
SELECT
    SUM(quantity_on_hand * unit_price) AS total_inventory_value
FROM inventoryitem;