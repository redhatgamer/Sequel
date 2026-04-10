import { useState, useEffect, useMemo } from 'react'

const API_URL = '/api'

export default function Suppliers() {
  const [suppliers, setSuppliers] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function fetchSuppliers() {
      try {
        const response = await fetch(`${API_URL}/suppliers`)
        if (!response.ok) throw new Error('Failed to load suppliers')
        setSuppliers(await response.json())
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchSuppliers()
  }, [])

  const filtered = useMemo(() => {
    if (!search) return suppliers
    const q = search.toLowerCase()
    return suppliers.filter(
      (s) =>
        (s.name || '').toLowerCase().includes(q) ||
        (s.email || '').toLowerCase().includes(q)
    )
  }, [suppliers, search])

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        Loading suppliers...
      </div>
    )
  }

  if (error) {
    return <div className="error">Error: {error}</div>
  }

  return (
    <>
      {suppliers.length === 0 ? (
        <div className="empty-state">
          <p>No suppliers found</p>
        </div>
      ) : (
        <div className="table-card">
          <div className="table-toolbar">
            <input
              type="text"
              className="search-input"
              placeholder="Search by name or email..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <span className="row-count">{filtered.length} suppliers</span>
          </div>
          <table>
            <thead>
              <tr>
                <th>Name</th>
                <th>Email</th>
                <th>Phone</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((s) => (
                <tr key={s.id ?? s.name}>
                  <td>{s.name || 'N/A'}</td>
                  <td>{s.email || 'N/A'}</td>
                  <td>{s.phone || 'N/A'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  )
}
