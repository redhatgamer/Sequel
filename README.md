# Sequel

Sequel is a prototype warehouse inventory management system. It is designed to
track inventory items, warehouses, suppliers, employees, and transactions. The
system uses a relational database to store and manage information related to
inventory, storage locations, and sales activity within a warehouse environment.

The goal of the system is to organize warehouse operations. It allows inventory
data to be stored, queried, and analyzed through database relationships and queries.

## Team Members

- Carlos Mejia
- Ashley Prado
- Gabriel Garcia
- Marcelo Hernandez Lopez

## Project Structure

```text
sequel/
├── database/
│   ├── schema.sql       # Table definitions
│   ├── data.sql         # Seed data
│   └── queries.sql      # Reporting queries
├── backend/
│   ├── app.py           # Flask API
│   └── requirements.txt
├── ui/                  # Frontend
├── docker-compose.yml
└── README.md
```

## Requirements

- Python 3.10+
- PostgreSQL 14+ **or** [Docker](https://www.docker.com/) and Docker Compose

## Database Setup

### Docker (recommended)

```bash
docker compose up -d
```

This starts PostgreSQL and automatically loads the schema and seed data
on first run. The database will be available at `localhost:5432`.

To stop:

```bash
docker compose down
```

To wipe and re-seed the database:

```bash
docker compose down -v
docker compose up -d
```

### Local PostgreSQL

Create the database and load the schema and sample data:

```bash
createdb sequel
psql sequel < database/schema.sql
psql sequel < database/seed.sql
```

If your PostgreSQL user is not `postgres`, open `backend/app.py` and update
the `DB_USER` and `DB_PASSWORD` values in `get_db_connection()` to match
your local credentials.

## Backend Setup

### 1. Create and activate a virtual environment

```bash
cd backend
python -m venv venv
```

Activate it:

- **macOS/Linux:** `source venv/bin/activate`
- **Windows (cmd):** `venv\Scripts\activate.bat`
- **Windows (PowerShell):** `venv\Scripts\Activate.ps1`

### 2. Install dependencies

```bash
pip install -r requirements.txt
```

### 3. Run the backend

```bash
python app.py
```

The API will be available at <http://localhost:5000>.
