import { Routes, Route, Link, Navigate } from 'react-router-dom';
import { useState } from 'react';
import Search from './Search';
import Library from './components/Library';
// import Login from './Login';
// import Register from './Register';

export default function App() {
  const [loggedIn, setLoggedIn] = useState(!!localStorage.getItem('jwt'));

  function handleLogout() {
    localStorage.removeItem('jwt');
    setLoggedIn(false);
  }

  return (
    <div style={{ padding: 20 }}>
      <nav>
        <Link to="/search">Search</Link>{' '}
        <Link to="/library">Library</Link>{' '}
        {loggedIn ? (
          <button onClick={handleLogout}>Logout</button>
        ) : (
          <>
            <Link to="/login">Login</Link>{' '}
            <Link to="/register">Register</Link>
          </>
        )}
      </nav>

      <Routes>
        <Route path="/" element={<h2>Welcome to Lalela!</h2>} />

        <Route
          path="/login"
          element={
            loggedIn ? (
              <Navigate to="/" />
            ) : (
              <Login onAuthenticated={() => setLoggedIn(true)} />
            )
          }
        />

        <Route
          path="/register"
          element={
            loggedIn ? (
              <Navigate to="/" />
            ) : (
              <Register onRegistered={() => {}} />
            )
          }
        />

        <Route path="/search" element={<Search />} />

        <Route
          path="/library"
          element={
            loggedIn ? <Library /> : <Navigate to="/login" />
          }
        />

        <Route path="*" element={<h2>404 Not Found</h2>} />
      </Routes>
    </div>
  );
}
