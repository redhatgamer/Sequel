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
        port="5432"
    )
    return conn

@app.route('/api/inventory', methods=['GET'])
def get_inventory():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, name, quantity_on_hand, unit_price, sku
            FROM inventoryitem
        """)
        
        rows = cursor.fetchall()
        inventory = [
            {
                'id': row[0],
                'name': row[1],
                'quantity_on_hand': row[2],
                'unit_price': float(row[3]) if row[3] else 0,
                'sku': row[4]
            }
            for row in rows
        ]
        
        cursor.close()
        conn.close()
        
        return jsonify(inventory)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/warehouses', methods=['GET'])
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
        warehouses = [
            {
                'id': row[0],
                'code': row[1],
                'street': row[2],
                'city': row[3],
                'state': row[4]
            }
            for row in rows
        ]
        
        cursor.close()
        conn.close()
        
        return jsonify(warehouses)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/suppliers', methods=['GET'])
def get_suppliers():
    try:
        conn = get_db_connection()
        cursor = conn.cursor()
        
        cursor.execute("""
            SELECT id, name, email, phone
            FROM supplier
        """)
        
        rows = cursor.fetchall()
        suppliers = [
            {
                'id': row[0],
                'name': row[1],
                'email': row[2],
                'phone': row[3]
            }
            for row in rows
        ]
        
        cursor.close()
        conn.close()
        
        return jsonify(suppliers)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

@app.route('/api/storage-locations', methods=['GET'])
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
        locations = [
            {
                'id': row[0],
                'warehouse_id': row[1],
                'aisle': row[2],
                'shelf': row[3],
                'bin': row[4],
                'warehouse_code': row[5]
            }
            for row in rows
        ]
        
        cursor.close()
        conn.close()
        
        return jsonify(locations)
    except Exception as e:
        return jsonify({'error': str(e)}), 500

if __name__ == "__main__":
    app.run(debug=True, host='localhost', port=5000)
