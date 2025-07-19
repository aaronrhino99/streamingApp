// src/services/api.js

// Base URL for your Rails API
const API_BASE_URL = import.meta.env.VITE_API_BASE_URL || 'http://localhost:3000/api/v1';

// Read stored JWT from localStorage
export const getAuthToken = () => localStorage.getItem('authToken');

// Core fetch wrapper
export const apiRequest = async (endpoint, options = {}) => {
  const url   = `${API_BASE_URL}${endpoint}`;
  const token = getAuthToken();

  const config = {
    headers: {
      'Content-Type': 'application/json',
      ...(token && { Authorization: `Bearer ${token}` }),
      ...options.headers,
    },
    ...options,
  };

  const response = await fetch(url, config);
  if (!response.ok) {
    throw new Error(`API Error: ${response.status}`);
  }
  // Try to parse JSON only if there is content
  const contentType = response.headers.get('content-type');
  if (contentType && contentType.includes('application/json')) {
    const data = await response.json();
    return { data, status: response.status };
  }
  return { data: null, status: response.status };
};

// ——————————————
// Songs API
// ——————————————

/**
 * Fetch all songs for the current user
 * GET /api/v1/songs
 */
export const getSongs = () =>
  apiRequest('/songs', { method: 'GET' });

/**
 * Fetch a single song’s metadata
 * GET /api/v1/songs/:id
 */
export const getSong = (id) =>
  apiRequest(`/songs/${id}`, { method: 'GET' });

/**
 * Delete a song
 * DELETE /api/v1/songs/:id
 */
export const deleteSong = (id) =>
  apiRequest(`/songs/${id}`, { method: 'DELETE' });

/**
 * Fetch playback metadata & signed stream URL
 * GET /api/v1/songs/:id/stream
 */
export const fetchStream = (songId) =>
  apiRequest(`/songs/${songId}/stream`, { method: 'GET' });

/**
 * Download (create) a new song record & start conversion
 * POST /api/v1/songs
 * body: { youtube_id, title, artist, thumbnail_url, duration }
 */
export const downloadSong = (songData) =>
  apiRequest('/songs', {
    method: 'POST',
    body: JSON.stringify({ song: songData }),
  });

// ——————————————
// Search API
// ——————————————

/**
 * Search YouTube via backend proxy
 * GET /api/v1/search?q=...
 */
export const searchSongs = (query) =>
  apiRequest(`/search?q=${encodeURIComponent(query)}`, {
    method: 'GET',
  });

// ——————————————
// Auth API
// ——————————————

/**
 * Log in with email/password 
 * POST /api/v1/auth/login
 * body: { email, password }
 */
export const login = (credentials) =>
  apiRequest('/auth/login', {
    method: 'POST',
    body: JSON.stringify(credentials),
  });

/**
 * Register a new user 
 * POST /api/v1/auth/register
 * body: { email, password, password_confirmation }
 */
export const register = (userData) =>
  apiRequest('/auth/register', {
    method: 'POST',
    body: JSON.stringify(userData),
  });

/**
 * Log out the current user
 * DELETE /api/v1/auth/logout
 */
export const logout = () =>
  apiRequest('/auth/logout', { method: 'DELETE' });

/**
 * Fetch the current user’s profile
 * GET /api/v1/auth/profile
 */
export const getProfile = () =>
  apiRequest('/auth/profile', { method: 'GET' });
