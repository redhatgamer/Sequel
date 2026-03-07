import psycopg2

def get_inventory():
    # replace "ashleyprado" with your local postgreSQL username
    conn = psycopg2.connect(
        dbname="sequel",
        user="ashleyprado",
        host="localhost",
        port="5432"
    )

    cursor = conn.cursor()

    cursor.execute("""
        SELECT name, quantity_on_hand
        FROM inventoryitem
    """)

    rows = cursor.fetchall()

    print("Inventory Report")

    for name, quantity in rows:
        print(f"{name}: {quantity} units")

    cursor.close()
    conn.close()


if __name__ == "__main__":
    get_inventory()