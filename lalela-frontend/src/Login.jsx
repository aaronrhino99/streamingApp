// src/Login.jsx
import { useState } from 'react';
export default function Login({ onLogin }) {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const handleSubmit = async e => {
    e.preventDefault();
    const res = await fetch(`${API}/users/sign_in`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ user: { email, password } }),
    });
    if (!res.ok) return alert('Login failed');
    const token = res.headers.get('Authorization') || (await res.json()).token;
    localStorage.setItem('jwt', token);
    onLogin();
  };
  return (
    <form onSubmit={handleSubmit}>
      <input value={email} onChange={e=>setEmail(e.target.value)} placeholder="Email"/>
      <input type="password" value={password} onChange={e=>setPassword(e.target.value)} placeholder="Password"/>
      <button type="submit">Login</button>
    </form>
  );
}
