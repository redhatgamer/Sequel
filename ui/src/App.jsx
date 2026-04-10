import { useState } from 'react'
import Dashboard from './components/Dashboard'
import Inventory from './components/Inventory'
import Warehouses from './components/Warehouses'
import Suppliers from './components/Suppliers'
import StorageLocations from './components/StorageLocations'

const TABS = [
  { id: 'dashboard', label: 'Dashboard', icon: '\u25A6' },
  { id: 'inventory', label: 'Inventory', icon: '\u25A8' },
  { id: 'warehouses', label: 'Warehouses', icon: '\u2302' },
  { id: 'suppliers', label: 'Suppliers', icon: '\u2AF6' },
  { id: 'storage', label: 'Storage', icon: '\u29C9' },
]

export default function App() {
  const [activeTab, setActiveTab] = useState('dashboard')

  return (
    <div className="app-layout">
      <aside className="sidebar">
        <div className="sidebar-brand">
          <span className="brand-icon">S</span>
          <h1>Sequel</h1>
        </div>
        <nav className="sidebar-nav">
          {TABS.map((tab) => (
            <button
              key={tab.id}
              className={`nav-item${activeTab === tab.id ? ' active' : ''}`}
              onClick={() => setActiveTab(tab.id)}
            >
              <span className="nav-icon">{tab.icon}</span>
              {tab.label}
            </button>
          ))}
        </nav>
        <div className="sidebar-footer">
          <p>Warehouse Management</p>
        </div>
      </aside>

      <main className="main-content">
        <div className="content-header">
          <h2>{TABS.find(t => t.id === activeTab)?.label}</h2>
        </div>
        <div className="tab-content" key={activeTab}>
          {activeTab === 'dashboard' && <Dashboard />}
          {activeTab === 'inventory' && <Inventory />}
          {activeTab === 'warehouses' && <Warehouses />}
          {activeTab === 'suppliers' && <Suppliers />}
          {activeTab === 'storage' && <StorageLocations />}
        </div>
      </main>
    </div>
  )
}
