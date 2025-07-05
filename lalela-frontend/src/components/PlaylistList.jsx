import { useEffect, useState } from "react";
import { Link, useNavigate } from "react-router-dom";

export default function PlaylistList() {
  const [playlists, setPlaylists] = useState([]);
  const [newName, setNewName] = useState("");
  const navigate = useNavigate();
  const API = import.meta.env.VITE_API_BASE_URL;

  const fetchPlaylists = async () => {
    const token = localStorage.getItem("jwt");
    const res = await fetch(`${API}/playlists`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.ok) setPlaylists(await res.json());
  };

  useEffect(() => {
    fetchPlaylists();
  }, []);

  const createPlaylist = async () => {
    if (!newName.trim()) return;
    const token = localStorage.getItem("jwt");
    const res = await fetch(`${API}/playlists`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body: JSON.stringify({ playlist: { name: newName } }),
    });
    if (res.ok) {
      const created = await res.json();
      setNewName("");
      navigate(`/playlists/${created.id}`);
    }
  };

  const deletePlaylist = async (id) => {
    const token = localStorage.getItem("jwt");
    await fetch(`${API}/playlists/${id}`, {
      method: "DELETE",
      headers: { Authorization: `Bearer ${token}` },
    });
    setPlaylists(playlists.filter((p) => p.id !== id));
  };

  return (
    <div style={{ padding: 20 }}>
      <h2>🎶 Your Playlists</h2>

      <div style={{ marginBottom: 16 }}>
        <input
          value={newName}
          onChange={(e) => setNewName(e.target.value)}
          placeholder="New playlist name"
          style={{ padding: 8, marginRight: 8 }}
        />
        <button onClick={createPlaylist}>➕ Create</button>
      </div>

      {playlists.length === 0 ? (
        <p>No playlists yet. Create one above!</p>
      ) : (
        <ul style={{ listStyle: "none", padding: 0 }}>
          {playlists.map((pl) => (
            <li
              key={pl.id}
              style={{
                marginBottom: 12,
                border: "1px solid #0f0",
                padding: 12,
                display: "flex",
                justifyContent: "space-between",
                alignItems: "center",
              }}
            >
              <Link to={`/playlists/${pl.id}`} style={{ color: "#0f0" }}>
                {pl.name} ({pl.songs.length} songs)
              </Link>
              <button onClick={() => deletePlaylist(pl.id)}>🗑️</button>
            </li>
          ))}
        </ul>
      )}
    </div>
  );
}
