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

## Starting the Project

- Refer to the README.md that is inside the UI folder.



The API will be available at <http://localhost:5000>.
