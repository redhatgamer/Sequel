import { useState, useEffect, useMemo } from 'react'

const API_URL = '/api'

export default function StorageLocations() {
  const [locations, setLocations] = useState([])
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)
  const [search, setSearch] = useState('')

  useEffect(() => {
    async function fetchLocations() {
      try {
        const response = await fetch(`${API_URL}/storage-locations`)
        if (!response.ok) throw new Error('Failed to load storage locations')
        setLocations(await response.json())
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchLocations()
  }, [])

  const filtered = useMemo(() => {
    if (!search) return locations
    const q = search.toLowerCase()
    return locations.filter(
      (loc) =>
        (loc.warehouse_code || '').toLowerCase().includes(q) ||
        (loc.aisle || '').toLowerCase().includes(q)
    )
  }, [locations, search])

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        Loading storage locations...
      </div>
    )
  }

  if (error) {
    return <div className="error">Error: {error}</div>
  }

  return (
    <>
      {locations.length === 0 ? (
        <div className="empty-state">
          <p>No storage locations found</p>
        </div>
      ) : (
        <div className="table-card">
          <div className="table-toolbar">
            <input
              type="text"
              className="search-input"
              placeholder="Search by warehouse or aisle..."
              value={search}
              onChange={(e) => setSearch(e.target.value)}
            />
            <span className="row-count">{filtered.length} locations</span>
          </div>
          <table>
            <thead>
              <tr>
                <th>Warehouse</th>
                <th>Aisle</th>
                <th>Shelf</th>
                <th>Bin</th>
              </tr>
            </thead>
            <tbody>
              {filtered.map((loc) => (
                <tr key={loc.id}>
                  <td><span className="mono">{loc.warehouse_code || 'N/A'}</span></td>
                  <td>{loc.aisle || 'N/A'}</td>
                  <td>{loc.shelf || 'N/A'}</td>
                  <td>{loc.bin || 'N/A'}</td>
                </tr>
              ))}
            </tbody>
          </table>
        </div>
      )}
    </>
  )
}
