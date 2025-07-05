import { useEffect, useState } from "react";
import { useParams } from "react-router-dom";

export default function PlaylistDetail() {
  const { id } = useParams();
  const [playlist, setPlaylist] = useState(null);
  const [allSongs, setAllSongs] = useState([]);
  const API = import.meta.env.VITE_API_BASE_URL;

  // Fetch playlist with its songs
  const fetchPlaylist = async () => {
    const token = localStorage.getItem("jwt");
    const res = await fetch(`${API}/playlists/${id}`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.ok) setPlaylist(await res.json());
  };

  // Also fetch all songs so you can add them
  const fetchSongs = async () => {
    const token = localStorage.getItem("jwt");
    const res = await fetch(`${API}/songs`, {
      headers: { Authorization: `Bearer ${token}` },
    });
    if (res.ok) setAllSongs(await res.json());
  };

  useEffect(() => {
    fetchPlaylist();
    fetchSongs();
  }, [id]);

  // Add or remove song from playlist
  const updateSongs = async (songId, add) => {
    const token = localStorage.getItem("jwt");
    const method = "PUT";
    const body = JSON.stringify({
      playlist: {
        song_ids: add
          ? [...playlist.songs.map((s) => s.id), songId]
          : playlist.songs.filter((s) => s.id !== songId).map((s) => s.id),
      },
    });
    await fetch(`${API}/playlists/${id}`, {
      method,
      headers: {
        "Content-Type": "application/json",
        Authorization: `Bearer ${token}`,
      },
      body,
    });
    fetchPlaylist();
  };

  if (!playlist) return <p>Loading playlist...</p>;

  const songIds = playlist.songs.map((s) => s.id);

  return (
    <div style={{ padding: 20 }}>
      <h2>📂 {playlist.name}</h2>

      <h3>Songs in this playlist</h3>
      {playlist.songs.length === 0 ? (
        <p>(No songs yet)</p>
      ) : (
        <ul>
          {playlist.songs.map((s) => (
            <li key={s.id} style={{ marginBottom: 8 }}>
              {s.title}{" "}
              <button onClick={() => updateSongs(s.id, false)}>➖ Remove</button>
            </li>
          ))}
        </ul>
      )}

      <h3>Add songs</h3>
      <ul>
        {allSongs.map((s) => (
          <li key={s.id} style={{ marginBottom: 8 }}>
            {s.title}{" "}
            {songIds.includes(s.id) ? (
              <span style={{ color: "#888", marginLeft: 8 }}>(Added)</span>
            ) : (
              <button onClick={() => updateSongs(s.id, true)}>➕ Add</button>
            )}
          </li>
        ))}
      </ul>
    </div>
  );
}
