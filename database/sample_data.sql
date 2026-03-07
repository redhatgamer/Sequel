-- address
INSERT INTO address VALUES
('a1','123 warehouse rd','miami',33101,'fl','usa','warehouse'),
('a2','100 fiu campus dr','miami',33199,'fl','usa','shipping'),
('a3','100 fiu campus dr','miami',33199,'fl','usa','billing');


-- person
INSERT INTO person VALUES
('p1','a2','a3','ashley','prado','ashley@fiu.edu','3050000001'),
('p2','a2','a3','carlos','mejia','carlos@fiu.edu','3050000002'),
('p3','a2','a3','gabriel','garcia','gabriel@fiu.edu','3050000003'),
('p4','a2','a3','marcelo','hernandez','marcelo@fiu.edu','3050000004');


-- supplier
INSERT INTO supplier VALUES
('s1','tech supplies inc','contact@techsupplies.com','3055551000'),
('s2','warehouse parts co','sales@warehouseparts.com','3055552000');


-- warehouse
INSERT INTO warehouse VALUES
('w1','miami warehouse','a1');


-- employee
INSERT INTO employee VALUES
('e1','p1','w1','manager','2026-01-01'),
('e2','p2','w1','staff','2026-01-01'),
('e3','p3','w1','staff','2026-01-01'),
('e4','p4','w1','staff','2026-01-01');


-- storage location
INSERT INTO storagelocation VALUES
('sl1','w1','a','1','01'),
('sl2','w1','a','1','02'),
('sl3','w1','b','2','05');


-- inventory item
INSERT INTO inventoryitem VALUES
('i1','sku1001','laptop',25,899.99,'w1','sl1','s1'),
('i2','sku1002','keyboard',100,49.99,'w1','sl2','s1'),
('i3','sku1003','mouse',150,29.99,'w1','sl3','s2');


-- purchase order
INSERT INTO purchaseorder VALUES
('po1','2025-01-10 10:00:00','completed',5000.00,'s1','w1'),
('po2','2025-02-05 11:30:00','pending',2000.00,'s2','w1');


-- sale
INSERT INTO sale VALUES
('sale1','p2','2026-03-01 14:00:00',979.97);


-- sale item
INSERT INTO saleitem VALUES
('si1','sale1','i1',1,899.99),
('si2','sale1','i2',2,39.99);


-- refund
INSERT INTO refund VALUES
('r1','sale1','2026-03-02 10:00:00',39.99);