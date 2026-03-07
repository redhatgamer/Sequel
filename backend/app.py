import sqlite3

def get_inventory():
    conn = sqlite3.connect("../database/warehouse.db")
    cursor = conn.cursor()

    cursor.execute("SELECT name, quantity_on_hand FROM inventoryitem")
    rows = cursor.fetchall()

    print("Inventory Report")

    for name, quantity in rows:
        print(f"{name}: {quantity} units")

    conn.close()

if __name__ == "__main__":
    get_inventory()