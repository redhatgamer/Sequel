import psycopg2
from flask import Flask, jsonify
from flask_cors import CORS

app = Flask(__name__)
CORS(app)


def get_db_connection():
    conn = psycopg2.connect(
        dbname="sequel",
        user="postgres",
        password="postgres",
        host="localhost",
        port="5432",
    )
    return conn


@app.route("/api/inventory", methods=["GET"])
def get_inventory():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT id, name, quantity_on_hand, unit_price, sku
            FROM inventoryitem
        """)

        rows = cursor.fetchall()

        result = [
            {
                "id": row[0],
                "name": row[1],
                "quantity_on_hand": row[2],
                "unit_price": float(row[3]) if row[3] else 0,
                "sku": row[4],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/warehouses", methods=["GET"])
def get_warehouses():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT w.id, w.code, a.street, a.city, a.state
            FROM warehouse w
            LEFT JOIN address a ON w.address_id = a.id
        """)

        rows = cursor.fetchall()

        result = [
            {
                "id": row[0],
                "code": row[1],
                "street": row[2],
                "city": row[3],
                "state": row[4],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/suppliers", methods=["GET"])
def get_suppliers():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT id, name, email, phone
            FROM supplier
        """)

        rows = cursor.fetchall()

        result = [
            {"id": row[0], "name": row[1], "email": row[2], "phone": row[3]}
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/storage-locations", methods=["GET"])
def get_storage_locations():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT sl.id, sl.warehouse_id, sl.aisle, sl.shelf, sl.bin, w.code
            FROM storagelocation sl
            JOIN warehouse w ON sl.warehouse_id = w.id
        """)

        rows = cursor.fetchall()

        result = [
            {
                "id": row[0],
                "warehouse_id": row[1],
                "aisle": row[2],
                "shelf": row[3],
                "bin": row[4],
                "warehouse_code": row[5],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/employees", methods=["GET"])
def employees():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT person.first_name, person.last_name, employee.role, warehouse.code
            FROM employee
            JOIN person ON employee.person_id = person.id
            JOIN warehouse ON employee.warehouse_id = warehouse.id
        """)

        rows = cursor.fetchall()

        result = [
            {
                "first_name": row[0],
                "last_name": row[1],
                "role": row[2],
                "warehouse": row[3],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/low-stock", methods=["GET"])
def low_stock():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT name, sku, quantity_on_hand
            FROM inventoryitem
            WHERE quantity_on_hand < 50
        """)

        rows = cursor.fetchall()

        result = [{"name": row[0], "sku": row[1], "quantity": row[2]} for row in rows]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/sales-history", methods=["GET"])
def sales_history():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT sale.id, person.first_name, person.last_name, sale.date, sale.total
            FROM sale
            JOIN person ON sale.customer_id = person.id
        """)

        rows = cursor.fetchall()

        result = [
            {
                "sale_id": row[0],
                "first_name": row[1],
                "last_name": row[2],
                "date": str(row[3]),
                "total": float(row[4]),
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/sales-items", methods=["GET"])
def sales_items():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT saleitem.sale_id, inventoryitem.name, saleitem.quantity, saleitem.price
            FROM saleitem
            JOIN inventoryitem ON saleitem.item_id = inventoryitem.id
        """)

        rows = cursor.fetchall()

        result = [
            {
                "sale_id": row[0],
                "product": row[1],
                "quantity": row[2],
                "price": float(row[3]),
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/inventory-value", methods=["GET"])
def inventory_value():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT COALESCE(SUM(quantity_on_hand * unit_price), 0)
            FROM inventoryitem
        """)

        value = cursor.fetchone()[0]

        cursor.close()
        conn.close()
        return jsonify({"total_inventory_value": float(value)})

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/customer-sales", methods=["GET"])
def customer_sales():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT person.first_name, person.last_name,
                   COUNT(sale.id), SUM(sale.total)
            FROM person
            JOIN sale ON person.id = sale.customer_id
            GROUP BY person.id, person.first_name, person.last_name
        """)

        rows = cursor.fetchall()

        result = [
            {
                "first_name": row[0],
                "last_name": row[1],
                "orders": row[2],
                "lifetime_value": float(row[3]),
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/warehouse-value", methods=["GET"])
def warehouse_value():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT warehouse.code,
                   COUNT(inventoryitem.id),
                   COALESCE(SUM(inventoryitem.quantity_on_hand * inventoryitem.unit_price), 0)
            FROM warehouse
            LEFT JOIN inventoryitem ON warehouse.id = inventoryitem.warehouse_id
            GROUP BY warehouse.id, warehouse.code
        """)

        rows = cursor.fetchall()

        result = [
            {"warehouse": row[0], "item_count": row[1], "value": float(row[2])}
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/order-fulfillment", methods=["GET"])
def order_fulfillment():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT sale.id,
                   person.first_name || ' ' || person.last_name,
                   inventoryitem.name,
                   saleitem.quantity,
                   warehouse.code,
                   storagelocation.aisle || '-' || storagelocation.shelf || '-' || storagelocation.bin,
                   employee.role
            FROM sale
            JOIN person ON sale.customer_id = person.id
            JOIN saleitem ON sale.id = saleitem.sale_id
            JOIN inventoryitem ON saleitem.item_id = inventoryitem.id
            JOIN warehouse ON inventoryitem.warehouse_id = warehouse.id
            JOIN storagelocation ON inventoryitem.storage_location_id = storagelocation.id
            LEFT JOIN employee ON warehouse.id = employee.warehouse_id
            WHERE sale.date > NOW() - INTERVAL '30 days'
        """)

        rows = cursor.fetchall()

        result = [
            {
                "sale_id": row[0],
                "customer": row[1],
                "product": row[2],
                "quantity": row[3],
                "warehouse": row[4],
                "location": row[5],
                "processed_by": row[6],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/refunds", methods=["GET"])
def refunds():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT refund.id, refund.date, refund.total, sale.id
            FROM refund
            JOIN sale ON refund.sale_id = sale.id
        """)

        rows = cursor.fetchall()

        result = [
            {
                "refund_id": row[0],
                "date": str(row[1]),
                "total": float(row[2]),
                "sale_id": row[3],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)

    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


@app.route("/api/supplier-inventory-summary", methods=["GET"])
def supplier_inventory_summary():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            SELECT purchaseorder.id,
                   purchaseorder.order_date,
                   purchaseorder.status,
                   purchaseorder.total_cost,
                   supplier.name,
                   supplier.email,
                   warehouse.code,
                   COUNT(inventoryitem.id),
                   COALESCE(SUM(inventoryitem.quantity_on_hand), 0)
            FROM purchaseorder
            JOIN supplier ON purchaseorder.supplier_id = supplier.id
            JOIN warehouse ON purchaseorder.warehouse_id = warehouse.id
            LEFT JOIN inventoryitem
                ON inventoryitem.supplier_id = supplier.id
                AND inventoryitem.warehouse_id = warehouse.id
            GROUP BY purchaseorder.id,
                     purchaseorder.order_date,
                     purchaseorder.status,
                     purchaseorder.total_cost,
                     supplier.name,
                     supplier.email,
                     warehouse.code
            ORDER BY purchaseorder.order_date DESC
        """)

        rows = cursor.fetchall()

        result = [
            {
                "order_id": row[0],
                "order_date": str(row[1]),
                "status": row[2],
                "total_cost": float(row[3]),
                "supplier": row[4],
                "supplier_email": row[5],
                "warehouse": row[6],
                "supplier_item_count": row[7],
                "supplier_total_units": row[8],
            }
            for row in rows
        ]

        cursor.close()
        conn.close()
        return jsonify(result)
    except Exception as e:
        print(e)
        return jsonify({"error": str(e)}), 500


if __name__ == "__main__":
    app.run(debug=True, host="localhost", port=5000)
