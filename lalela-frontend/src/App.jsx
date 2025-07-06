// src/App.jsx
import { useState } from 'react';
import { Routes, Route, Link, Navigate } from 'react-router-dom';
import Welcome  from './components/Welcome';
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
      {/* Nav - only show on non-welcome pages */}
      {loggedIn && window.location.pathname !== '/' && (
        <nav className="p-4 border-b border-gray-200 bg-gray-50">
          <div className="flex items-center justify-between">
            <div className="flex items-center space-x-4">
              <Link to="/" className="text-indigo-600 hover:text-indigo-800 font-semibold">
                Lalela
              </Link>
              <Link to="/search" className="text-gray-600 hover:text-gray-800">
                Search
              </Link>
              <Link to="/library" className="text-gray-600 hover:text-gray-800">
                Library
              </Link>
            </div>
            <button 
              onClick={handleLogout}
              className="bg-red-500 text-white px-3 py-1 rounded hover:bg-red-600 transition-colors"
            >
              Logout
            </button>
          </div>
        </nav>
      )}
      
      {/* Nav for non-logged in users */}
      {!loggedIn && (
        <nav className="p-4 border-b border-gray-200 bg-gray-50">
          <div className="flex items-center space-x-4">
            <Link to="/login" className="text-indigo-600 hover:text-indigo-800">
              Login
            </Link>
            <Link to="/register" className="text-indigo-600 hover:text-indigo-800">
              Register
            </Link>
          </div>
        </nav>
      )}

      {/* Content */}
      <div>
        <Routes>
          {/* Home/Welcome route */}
          <Route 
            path="/"              
            element={<Welcome onLogin={handleLogin} />} 
          />
          
          {/* Public routes */}
          <Route
            path="/login"
            element={loggedIn
              ? <Navigate to="/" />
              : <Login onLogin={handleLogin} />
            }
          />
          <Route
            path="/register"
            element={loggedIn
              ? <Navigate to="/" />
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