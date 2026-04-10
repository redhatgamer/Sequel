-- CONSTRAINT TEST 1: FOREIGN KEY VIOLATION

-- Attempt to create an employee referencing a non-existent person
INSERT INTO Employee (id, person_id, warehouse_id, role, hire_date)
VALUES (
    uuid_generate_v4(),
    'a1b2c3d4-e5f6-7890-abcd-ef1234567890', -- non-existent UUID
    (SELECT id FROM Warehouse LIMIT 1),
    'Manager',
    '2024-01-15'
);

-- ERROR: insert or update on table "employee" violates foreign key constraint "employee_person_id_fkey"
-- DETAIL: Key (person_id)=(a1b2c3d4-e5f6-7890-abcd-ef1234567890) is not present in table "person".


-- CONSTRAINT TEST 2: UNIQUE CONSTRAINT VIOLATION

-- First, insert a person with a phone number
INSERT INTO Person (id, first_name, last_name, email, phone)
VALUES (
    uuid_generate_v4(),
    'John',
    'Doe',
    'john.doe@example.com',
    '555-123-4567'
);

-- Attempt to insert another person with the same phone number
INSERT INTO Person (id, first_name, last_name, email, phone)
VALUES (
    uuid_generate_v4(),
    'Jane',
    'Smith',
    'jane.smith@example.com',
    '555-123-4567'  -- duplicate phone
);

-- ERROR: duplicate key value violates unique constraint "person_phone_key"
-- DETAIL: Key (phone)=(555-123-4567) already exists.


-- CONSTRAINT TEST 3: NOT NULL VIOLATION

-- Attempt to insert an address with NULL street
INSERT INTO Address (id, street, city, postal_code, state, country, type)
VALUES (
    uuid_generate_v4(),
    NULL,  -- street cannot be NULL
    'New York',
    10001,
    'NY',
    'USA',
    'Shipping'
);

-- ERROR: null value in column "street" of relation "address" violates not-null constraint
-- DETAIL: Failing row contains (..., null, New York, 10001, NY, USA, Shipping).