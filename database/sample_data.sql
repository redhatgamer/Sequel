-- Adress DATA
INSERT INTO
  Address (street, city, postal_code, state, country, type)
VALUES
  (
    '123 Warehouse Rd',
    'Miami',
    33101,
    'FL',
    'USA',
    'warehouse'
  ),
  (
    '100 FIU Campus Dr',
    'Miami',
    33199,
    'FL',
    'USA',
    'shipping'
  ),
  (
    '100 FIU Campus Dr',
    'Miami',
    33199,
    'FL',
    'USA',
    'billing'
  );

-- Suppliers
INSERT INTO
  Supplier (name, email, phone)
VALUES
  (
    'Tech Supplies Inc',
    'contact@techsupplies.com',
    '3055551000'
  ),
  (
    'Warehouse Parts Co',
    'sales@warehouseparts.com',
    '3055552000'
  );

-- warehouse
INSERT INTO
  Warehouse (code, address_id)
VALUES
  (
    'MIAMI-WH',
    (
      SELECT
        id
      FROM
        Address
      WHERE
        type = 'warehouse'
      LIMIT
        1
    )
  );

-- storage location
INSERT INTO
  StorageLocation (warehouse_id, aisle, shelf, bin)
VALUES
  (
    (
      SELECT
        id
      FROM
        Warehouse
      LIMIT
        1
    ),
    'A',
    '1',
    '01'
  ),
  (
    (
      SELECT
        id
      FROM
        Warehouse
      LIMIT
        1
    ),
    'A',
    '1',
    '02'
  );

-- person customer
INSERT INTO
  Person (
    shipping_address_id,
    billing_address_id,
    first_name,
    last_name,
    email,
    phone
  )
VALUES
  (
    (
      SELECT
        id
      FROM
        Address
      WHERE
        type = 'shipping'
      LIMIT
        1
    ),
    (
      SELECT
        id
      FROM
        Address
      WHERE
        type = 'billing'
      LIMIT
        1
    ),
    'Ashley',
    'Prado',
    'ashley@fiu.edu',
    '3055553000'
  );

-- inventory items
INSERT INTO
  InventoryItem (
    sku,
    name,
    quantity_on_hand,
    unit_price,
    warehouse_id,
    storage_location_id,
    supplier_id
  )
VALUES
  (
    'SKU1001',
    'Laptop',
    25,
    899.99,
    (
      SELECT
        id
      FROM
        Warehouse
      LIMIT
        1
    ),
    (
      SELECT
        id
      FROM
        StorageLocation
      LIMIT
        1
    ),
    (
      SELECT
        id
      FROM
        Supplier
      WHERE
        name = 'Tech Supplies Inc'
      LIMIT
        1
    )
  ),
  (
    'SKU1002',
    'Keyboard',
    100,
    49.99,
    (
      SELECT
        id
      FROM
        Warehouse
      LIMIT
        1
    ),
    (
      SELECT
        id
      FROM
        StorageLocation
      LIMIT
        1
      OFFSET
        1
    ),
    (
      SELECT
        id
      FROM
        Supplier
      WHERE
        name = 'Tech Supplies Inc'
      LIMIT
        1
    )
  );

-- sale
INSERT INTO
  Sale (customer_id, date, total)
VALUES
  (
    (
      SELECT
        id
      FROM
        Person
      LIMIT
        1
    ),
    NOW (),
    949.98
  );

-- sale item
INSERT INTO
  SaleItem (sale_id, item_id, quantity, price)
VALUES
  (
    (
      SELECT
        id
      FROM
        Sale
      LIMIT
        1
    ),
    (
      SELECT
        id
      FROM
        InventoryItem
      WHERE
        sku = 'SKU1001'
    ),
    1,
    899.99
  );

-- orders
INSERT INTO PurchaseOrder (order_date, status, total_cost, supplier_id, warehouse_id)
VALUES
  (
    NOW() - INTERVAL '10 days',
    'received',
    22474.75,
    (SELECT id FROM Supplier WHERE name = 'Tech Supplies Inc'),
    (SELECT id FROM Warehouse LIMIT 1)
  ),
  (
    NOW() - INTERVAL '2 days',
    'pending',
    4999.00,
    (SELECT id FROM Supplier WHERE name = 'Warehouse Parts Co'),
    (SELECT id FROM Warehouse LIMIT 1)
  );
