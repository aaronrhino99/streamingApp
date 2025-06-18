import { useState } from 'react';

export default function Register() {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const API = import.meta.env.VITE_API_BASE_URL;

  const handleSubmit = async e => {
    e.preventDefault();
    try {
      const res = await fetch(`${API}/users`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          user: { email, password, password_confirmation: password }
        })
      });
      if (!res.ok) throw new Error(`Registration failed: ${res.status}`);
      alert('Registered! Please log in.');
      setEmail('');
      setPassword('');
    } catch (err) {
      console.error(err);
      alert('Registration error—check console.');
    }
  };

  return (
    <form onSubmit={handleSubmit} style={{ padding: 20 }}>
      <h2>Register</h2>
      <div style={{ marginBottom: 12 }}>
        <input
          type="email"
          value={email}
          onChange={e => setEmail(e.target.value)}
          placeholder="Email"
          required
          style={{ width: 300, padding: 8 }}
        />
      </div>
      <div style={{ marginBottom: 12 }}>
        <input
          type="password"
          value={password}
          onChange={e => setPassword(e.target.value)}
          placeholder="Password"
          required
          style={{ width: 300, padding: 8 }}
        />
      </div>
      <button type="submit" style={{ padding: '8px 16px' }}>
        Register
      </button>
    </form>
  );
}