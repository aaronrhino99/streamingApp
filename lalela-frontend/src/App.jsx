import { useState } from 'react';
import { Routes, Route, Link, Navigate, useNavigate } from 'react-router-dom';
import Welcome from './components/Welcome';
import Search from './Search';
import Library from './components/Library';
import Login from './Login';
import Register from './Register';
import { apiRequest } from './services/api';

export default function App() {
  const navigate = useNavigate();
  // Determine initial login state based on JWT presence
  const [loggedIn, setLoggedIn] = useState(!!localStorage.getItem('authToken'));

  // Handle successful login: store token, set state, redirect
  const handleLogin = (token) => {
    localStorage.setItem('authToken', token);
    setLoggedIn(true);
    navigate('/search');
  };

  // Handle logout: call API, clear token, update state, redirect
  const handleLogout = async () => {
    try {
      await apiRequest('/auth/logout', { method: 'DELETE' });
    } catch (err) {
      console.error('Logout failed', err);
    }
    localStorage.removeItem('authToken');
    setLoggedIn(false);
    navigate('/login');
  };

  return (
    <div>
      {/* Authenticated nav */}
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

      {/* Public nav */}
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

      {/* Main content routes */}
      <div>
        <Routes>
          {/* Welcome/Home */}
          <Route
            path="/"
            element={<Welcome onLogin={handleLogin} />}
          />

          {/* Login */}
          <Route
            path="/login"
            element={
              loggedIn
                ? <Navigate to="/search" />
                : <Login onLogin={handleLogin} />
            }
          />

          {/* Register */}
          <Route
            path="/register"
            element={
              loggedIn
                ? <Navigate to="/search" />
                : <Register onRegister={handleLogin} />
            }
          />

          {/* Protected routes */}
          <Route
            path="/search"
            element={
              loggedIn
                ? <Search />
                : <Navigate to="/login" />
            }
          />
          <Route
            path="/library"
            element={
              loggedIn
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
