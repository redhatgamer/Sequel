-- address table
CREATE TABLE Address (
    id UUID PRIMARY KEY,
    street VARCHAR(100) NOT NULL,
    city VARCHAR(50) NOT NULL,
    postal_code INT NOT NULL,
    state VARCHAR(50) NOT NULL,
    country VARCHAR(50) NOT NULL,
    type VARCHAR(20) NOT NULL
);

-- person table
CREATE TABLE Person (
    id UUID PRIMARY KEY,
    shipping_address_id UUID,
    billing_address_id UUID,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    email VARCHAR(100) NOT NULL,
    phone VARCHAR(20) UNIQUE,
    FOREIGN KEY (shipping_address_id) REFERENCES Address(id),
    FOREIGN KEY (billing_address_id) REFERENCES Address(id)
);

-- supplier table
CREATE TABLE Supplier (
    id UUID PRIMARY KEY,
    name VARCHAR(100),
    email VARCHAR(100),
    phone VARCHAR(20)
);

-- warehouse table
CREATE TABLE Warehouse (
    id UUID PRIMARY KEY,
    code VARCHAR(50) UNIQUE,
    address_id UUID,
    FOREIGN KEY (address_id) REFERENCES Address(id)
);

-- employee table
CREATE TABLE Employee (
    id UUID PRIMARY KEY,
    person_id UUID,
    warehouse_id UUID,
    role VARCHAR(50),
    hire_date DATE,
    FOREIGN KEY (person_id) REFERENCES Person(id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(id)
);

-- storage location table
CREATE TABLE StorageLocation (
    id UUID PRIMARY KEY,
    warehouse_id UUID,
    aisle VARCHAR(10),
    shelf VARCHAR(10),
    bin VARCHAR(10),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(id)
);

-- Inventory item table
CREATE TABLE InventoryItem (
    id UUID PRIMARY KEY,
    sku VARCHAR(50) UNIQUE,
    name VARCHAR(100),
    quantity_on_hand INT,
    unit_price DECIMAL(10,2),
    warehouse_id UUID,
    storage_location_id UUID,
    supplier_id UUID,
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(id),
    FOREIGN KEY (storage_location_id) REFERENCES StorageLocation(id),
    FOREIGN KEY (supplier_id) REFERENCES Supplier(id)
);

-- Purchase order 
CREATE TABLE PurchaseOrder (
    id UUID PRIMARY KEY,
    order_date TIMESTAMP,
    status VARCHAR(50),
    total_cost DECIMAL(10,2),
    supplier_id UUID,
    warehouse_id UUID,
    FOREIGN KEY (supplier_id) REFERENCES Supplier(id),
    FOREIGN KEY (warehouse_id) REFERENCES Warehouse(id)
);

-- sale table
CREATE TABLE Sale (
    id UUID PRIMARY KEY,
    customer_id UUID,
    date TIMESTAMP,
    total DECIMAL(10,2),
    FOREIGN KEY (customer_id) REFERENCES Person(id)
);

-- sale item table
CREATE TABLE SaleItem (
    id UUID PRIMARY KEY,
    sale_id UUID,
    item_id UUID,
    quantity INT,
    price DECIMAL(10,2),
    FOREIGN KEY (sale_id) REFERENCES Sale(id),
    FOREIGN KEY (item_id) REFERENCES InventoryItem(id)
);

-- refund table
CREATE TABLE Refund (
    id UUID PRIMARY KEY,
    sale_id UUID,
    date TIMESTAMP,
    total DECIMAL(10,2),
    FOREIGN KEY (sale_id) REFERENCES Sale(id)
);