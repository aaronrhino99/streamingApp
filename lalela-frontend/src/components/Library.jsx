// src/components/Library.jsx
import { useEffect, useState } from "react";
import useHowl from "../hooks/useHowl";

export default function Library() {
  const [songs, setSongs] = useState([]);
  const [currentUrl, setCurrentUrl] = useState(null);
  const { playing, play, pause } = useHowl(currentUrl);
  const API = import.meta.env.VITE_API_BASE_URL;

  useEffect(() => {
    // Include JWT in the Authorization header
    const token = localStorage.getItem("jwt");
    fetch(`${API}/songs`, {
      headers: { Authorization: `Bearer ${token}` },
    })
      .then((res) => {
        if (!res.ok) throw new Error("Failed to load songs");
        return res.json();
      })
      .then(setSongs)
      .catch((err) => {
        console.error(err);
        alert("Error loading library");
      });
  }, [API]);

  return (
    <div style={{ padding: 20 }}>
      <h2>🎵 Your Library</h2>
      {songs.length === 0 && (
        <p>No songs yet. Head over to Search to download one!</p>
      )}

      <ul style={{ listStyle: "none", padding: 0 }}>
        {songs.map((song) => {
          const url = `${API}${song.audio_file_url}`;
          return (
            <li key={song.id} className="matrix-card">
              <div style={{ flex: 1 }}>
                <div style={{ fontWeight: 500 }}>{song.title}</div>
                <div style={{ marginTop: 8 }}>
                  {currentUrl === url && playing ? (
                    <button onClick={pause}>⏸️ Pause</button>
                  ) : (
                    <button
                      onClick={() => {
                        if (currentUrl !== url) setCurrentUrl(url);
                        play();
                      }}
                    >
                      ▶️ {currentUrl === url && !playing ? "Resume" : "Play"}
                    </button>
                  )}
                </div>
              </div>
            </li>
          );
        })}
      </ul>
    </div>
  );
}
