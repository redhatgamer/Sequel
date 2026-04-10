# Sequel UI

React frontend for the Warehouse Inventory Management System.

## Prerequisites

- [Node.js](https://nodejs.org/) (v18+)
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- Python 3

## Getting Started

**1. Start the database** (from the project root):

```
docker compose up -d
```

**2. Start the backend:**

```
cd backend
python app.py
```

**3. Start the React dev server:**

```
cd ui
npm install
npm run dev
```

**4. Open** http://localhost:3000
