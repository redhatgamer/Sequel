import { useState, useEffect, useMemo } from 'react'

const API_URL = '/api'

function fmt(n) {
  return n.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })
}

function stockLevel(qty) {
  if (qty === 0) return 'out'
  if (qty <= 10) return 'low'
  if (qty <= 50) return 'medium'
  return 'good'
}

export default function Inventory() {
  const [items, setItems] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function fetchInventory() {
      try {
        const response = await fetch(`${API_URL}/inventory`)
        if (!response.ok) throw new Error('Failed to load inventory')
        setItems(await response.json())
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchInventory()
  }, [])

  const filtered = useMemo(() => {
    if (!search) return items
    const q = search.toLowerCase()
    return items.filter(
      (item) =>
        item.sku.toLowerCase().includes(q) ||
        item.name.toLowerCase().includes(q)
    )
  }, [items, search])

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        Loading inventory...
      </div>
    )
  }

  if (error) {
    return <div className="error">Error: {error}</div>
  }

  return (
    <>
      {items.length === 0 ? (
        <div className="empty-state">
          <p>No inventory items found</p>
        </div>
      ) : (
        <div className="table-card">
          <div className="table-toolbar">
            <input
              type="text"
              className="search-input"
              placeholder="Search by SKU or name..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <span className="row-count">{filtered.length} items</span>
          </div>
          <table>
            <thead>
              <tr>
                <th>SKU</th>
                <th>Name</th>
                <th>Quantity</th>
                <th>Unit Price</th>
                <th>Total Value</th>
                <th>Status</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((item) => (
                <tr key={item.id ?? item.sku}>
                  <td><span className="mono">{item.sku}</span></td>
                  <td>{item.name}</td>
                  <td>{item.quantity_on_hand.toLocaleString()}</td>
                  <td>${fmt(item.unit_price)}</td>
                  <td>${fmt(item.quantity_on_hand * item.unit_price)}</td>
                  <td><span className={`badge badge-${stockLevel(item.quantity_on_hand)}`}>
                    {stockLevel(item.quantity_on_hand) === 'out' ? 'Out of Stock'
                      : stockLevel(item.quantity_on_hand) === 'low' ? 'Low Stock'
                      : stockLevel(item.quantity_on_hand) === 'medium' ? 'Medium'
                      : 'In Stock'}
                  </span></td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  )
}
