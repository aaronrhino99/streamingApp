// src/Login.jsx
import { useState } from 'react';
import { useNavigate } from 'react-router-dom';

export default function Login({ onLogin }) {
  const [formData, setFormData] = useState({
    email: '',
    password: ''
  });
  const [error, setError] = useState('');
  const [isLoading, setIsLoading] = useState(false);
  const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api/v1';
  const navigate = useNavigate();

  const handleChange = (e) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');
    setIsLoading(true);

    try {
      const res = await fetch(`${API_BASE_URL}/auth/login`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify(formData),
      });

      if (!res.ok) {
        const errorData = await res.json().catch(() => ({}));
        throw new Error(errorData.message || 'Login failed');
      }

      const { token } = await res.json();
      localStorage.setItem('jwt', token);
      onLogin();
      navigate('/search');
    } catch (err) {
      console.error('Login error:', err);
      setError(err.message || 'Invalid email or password');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="pb-32 flex flex-col items-center justify-center min-h-screen bg-indigo-500">
      <div className="max-w-2xl w-full mx-auto flex flex-col items-center space-y-4">
        <h1 className="font-bold text-7xl text-indigo-100">Soundcloud</h1>
        <p className="text-lg text-gray-200">Share your music with the world!</p>

        {error && (
          <div className="bg-red-200 text-red-800 p-2 rounded">
            {error}
          </div>
        )}

        <form
          onSubmit={handleSubmit}
          className="bg-white bg-opacity-90 p-8 rounded-lg shadow-lg w-full max-w-md space-y-6"
        >
          <div className="flex flex-col">
            <label htmlFor="email" className="mb-1 font-medium text-gray-700">
              Email
            </label>
            <input
              type="email"
              id="email"
              name="email"
              value={formData.email}
              onChange={handleChange}
              placeholder="you@example.com"
              required
              autoComplete="username"
              className="px-4 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-indigo-400"
            />
          </div>

          <div className="flex flex-col">
            <label htmlFor="password" className="mb-1 font-medium text-gray-700">
              Password
            </label>
            <input
              type="password"
              id="password"
              name="password"
              value={formData.password}
              onChange={handleChange}
              placeholder="••••••••"
              required
              autoComplete="current-password"
              className="px-4 py-2 border border-gray-300 rounded focus:outline-none focus:ring-2 focus:ring-indigo-400"
            />
          </div>

          <button
            type="submit"
            disabled={isLoading}
            className="w-full bg-purple-500 text-purple-100 py-2 rounded-lg font-semibold hover:bg-purple-600 transition"
          >
            {isLoading ? 'Logging in...' : 'Login'}
          </button>
        </form>

        <div className="flex space-x-4">
          <a
            href="/register"
            className="bg-green-500 text-green-100 p-2 rounded-lg w-32 text-center hover:bg-green-600 transition"
          >
            Register
          </a>
        </div>
      </div>
    </div>
  );
}
