import { useState, useEffect, useMemo } from 'react'

const API_URL = '/api'

export default function Warehouses() {
  const [warehouses, setWarehouses] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function fetchWarehouses() {
      try {
        const response = await fetch(`${API_URL}/warehouses`)
        if (!response.ok) throw new Error('Failed to load warehouses')
        setWarehouses(await response.json())
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchWarehouses()
  }, [])

  const filtered = useMemo(() => {
    if (!search) return warehouses
    const q = search.toLowerCase()
    return warehouses.filter(
      (w) =>
        (w.code || '').toLowerCase().includes(q) ||
        (w.city || '').toLowerCase().includes(q) ||
        (w.state || '').toLowerCase().includes(q)
    )
  }, [warehouses, search])

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        Loading warehouses...
      </div>
    )
  }

  if (error) {
    return <div className="error">Error: {error}</div>
  }

  return (
    <>
      {warehouses.length === 0 ? (
        <div className="empty-state">
          <p>No warehouses found</p>
        </div>
      ) : (
        <div className="table-card">
          <div className="table-toolbar">
            <input
              type="text"
              className="search-input"
              placeholder="Search by code, city, or state..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <span className="row-count">{filtered.length} warehouses</span>
          </div>
          <table>
            <thead>
              <tr>
                <th>Code</th>
                <th>Street</th>
                <th>City</th>
                <th>State</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((w) => (
                <tr key={w.id ?? w.code}>
                  <td><span className="mono">{w.code || 'N/A'}</span></td>
                  <td>{w.street || 'N/A'}</td>
                  <td>{w.city || 'N/A'}</td>
                  <td>{w.state || 'N/A'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  )
}
