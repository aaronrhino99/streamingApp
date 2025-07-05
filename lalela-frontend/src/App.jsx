// src/App.jsx
import { useState } from 'react';
import { Routes, Route, Link, Navigate } from 'react-router-dom';

import Search   from './Search';
import Library  from './components/Library';
import Login    from './Login';
import Register from './Register';

export default function App() {
  // Kick off loggedIn based on presence of a JWT
  const [loggedIn, setLoggedIn] = useState(!!localStorage.getItem('jwt'));

  const handleLogin = () => setLoggedIn(true);
  const handleLogout = () => {
    localStorage.removeItem('jwt');
    setLoggedIn(false);
  };

  return (
    <div>
      {/* Nav always visible */}
      <nav style={{ padding: 16, borderBottom: '1px solid #0f0' }}>
        {!loggedIn ? (
          <>
            <Link to="/login"    style={{ marginRight: 12 }}>Login</Link>
            <Link to="/register">Register</Link>
          </>
        ) : (
          <>
            <Link to="/search"  style={{ marginRight: 12 }}>Search</Link>
            <Link to="/library" style={{ marginRight: 12 }}>Library</Link>
            <button onClick={handleLogout}>Logout</button>
          </>
        )}
      </nav>

      {/* Content */}
      <div style={{ padding: 20 }}>
        <Routes>
          {/* Redirect root */}
          <Route path="/" element={<Navigate to={loggedIn ? "/search" : "/login"} />} />

          {/* Public routes */}
          <Route
            path="/login"
            element={loggedIn
              ? <Navigate to="/search" />
              : <Login onLogin={handleLogin} />
            }
          />
          <Route
            path="/register"
            element={loggedIn
              ? <Navigate to="/search" />
              : <Register />
            }
          />

          {/* Protected routes */}
          <Route
            path="/search"
            element={loggedIn
              ? <Search />
              : <Navigate to="/login" />
            }
          />
          <Route
            path="/library"
            element={loggedIn
              ? <Library />
              : <Navigate to="/login" />
            }
          />

          {/* Fallback 404 */}
          <Route path="*" element={<h2>404: Page Not Found</h2>} />
        </Routes>
      </div>
    </div>
  );
}
