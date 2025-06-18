
import { Routes, Route, Link, Navigate, useNavigate } from 'react-router-dom';
import { useState } from 'react';
import Search from './Search';
import Library from './components/Library';
import Login from './Login';
import Register from './Register';
import Login from './Login';
import Register from './Register';

export default function App() {
  const [loggedIn, setLoggedIn] = useState(!!localStorage.getItem('jwt'));
  const navigate = useNavigate();

  function handleLogout() {
   localStorage.removeItem('jwt');
   setLoggedIn(false);
   navigate('/login');
  }

return (
export default function App() {
<Routes>
<Route path="/" element={<h2>Welcome to Lalela!</h2>} />
<Route
path="/login"
element={
loggedIn ? (
-              <Navigate to="/" />
-            ) : (
-              <Login onAuthenticated={() => setLoggedIn(true)} />
-            )
-          }
-        />
        <Route
          path="/login"
          element={
            loggedIn ? (
              <Navigate to="/search" replace />
            ) : (
              <Login onAuthenticated={() => {
                setLoggedIn(true);
                navigate('/search');
              }} />
            )
          }
        />

-        <Route
-          path="/register"
-          element={
-            loggedIn ? (
-              <Navigate to="/" />
-            ) : (
-              <Register onRegistered={() => {}} />
-            )
-          }
-        />
        <Route
          path="/register"
          element={
            loggedIn ? (
              <Navigate to="/search" replace />
            ) : (
              <Register onRegistered={() => {
                // after registering, send user to login
                navigate('/login');
              }} />
            )
          }
        />

-        <Route path="/search" element={<Search />} />
        <Route
          path="/search"
          element={
            loggedIn
              ? <Search />
              : <Navigate to="/login" replace />
          }
        />

-        <Route
-          path="/library"
-          element={
-            loggedIn ? <Library /> : <Navigate to="/login" />
-          }
-        />
        <Route
          path="/library"
          element={
            loggedIn
              ? <Library />
              : <Navigate to="/login" replace />
          }
        />

<Route path="*" element={<h2>404 Not Found</h2>} />
</Routes>
