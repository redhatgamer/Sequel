import { useState, useEffect } from 'react'

const API_URL = '/api'

export default function Dashboard() {
  const [stats, setStats] = useState(null)
  const [loading, setLoading] = useState(true)
  const [error, setError] = useState(null)

  useEffect(() => {
    async function fetchStats() {
      try {
        const [inventory, warehouses, suppliers, locations] = await Promise.all([
          fetch(`${API_URL}/inventory`).then((r) => r.json()),
          fetch(`${API_URL}/warehouses`).then((r) => r.json()),
          fetch(`${API_URL}/suppliers`).then((r) => r.json()),
          fetch(`${API_URL}/storage-locations`).then((r) => r.json()),
        ])

        const totalUnits = inventory.reduce((sum, item) => sum + item.quantity_on_hand, 0)
        const totalValue = inventory.reduce(
          (sum, item) => sum + item.quantity_on_hand * item.unit_price,
          0
        )

        setStats({
          itemCount: inventory.length,
          totalUnits,
          totalValue,
          warehouseCount: warehouses.length,
          supplierCount: suppliers.length,
          locationCount: locations.length,
        })
      } catch (err) {
        setError(err.message)
      } finally {
        setLoading(false)
      }
    }

    fetchStats()
  }, [])

  if (loading) {
    return (
      <div className="loading">
        <div className="spinner"></div>
        Loading dashboard...
      </div>
    )
  }

  if (error) {
    return <div className="error">Error: {error}</div>
  }

  return (
    <>
      <div className="stats">
        <div className="stat-card">
          <h3>{stats.itemCount.toLocaleString()}</h3>
          <p>Total Inventory Items</p>
        </div>
        <div className="stat-card">
          <h3>{stats.totalUnits.toLocaleString()}</h3>
          <p>Total Units in Stock</p>
        </div>
        <div className="stat-card">
          <h3>${stats.totalValue.toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 })}</h3>
          <p>Total Inventory Value</p>
        </div>
        <div className="stat-card">
          <h3>{stats.warehouseCount.toLocaleString()}</h3>
          <p>Active Warehouses</p>
        </div>
        <div className="stat-card">
          <h3>{stats.supplierCount.toLocaleString()}</h3>
          <p>Registered Suppliers</p>
        </div>
        <div className="stat-card">
          <h3>{stats.locationCount}</h3>
          <p>Storage Locations</p>
        </div>
      </div>
    </>
  )
}
