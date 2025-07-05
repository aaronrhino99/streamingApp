import { useState } from "react";
import styles from "./Search.module.css";

export default function Search() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);

  const API = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000/api/v1";

  const searchSongs = async () => {
    if (!query.trim()) return;
    try {
      const res = await fetch(`${API}/search?q=${encodeURIComponent(query)}`, {
        headers: { Authorization: `Bearer ${localStorage.getItem("jwt")}` },
      });
      if (!res.ok) throw new Error(`Server error: ${res.status}`);
      const data = await res.json();
      setResults(data);
    } catch (err) {
      console.error("❌ Search failed:", err);
      alert("Error fetching search results—check console.");
    }
  };

  const downloadSong = async (video) => {
    try {
      const token = localStorage.getItem("jwt");
      const res = await fetch(`${API}/songs`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify({
          title: video.title,
          video_id: video.video_id,
          title: video.title,
          youtube_id: video.video_id,
          thumbnail_url: video.thumbnail_url,
        }),
      });
      if (!res.ok) throw new Error("Download request failed");
      alert("Download started!");
    } catch (err) {
      console.error("Download failed:", err);
      alert("Error starting download");
    }
  };

  return (
    <div className={styles.container}>
      <h2 className={styles.title}>🔍 Search YouTube</h2>

      <div className={styles.controls}>
        <input
          className={styles.input}
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search for a song..."
          onKeyDown={(e) => e.key === "Enter" && searchSongs()}
        />
        <button className={styles.button} onClick={searchSongs}>
          Search
        </button>
      </div>

      <div className={styles.results}>
        {results.length === 0 ? (
          <p>No results yet</p>
        ) : (
          results.map((video) => (
            <div key={video.video_id} className={styles.card}>
              <img
                className={styles.thumbnail}
                src={video.thumbnail_url}
                alt={video.title}
              />
              <div style={{ flex: 1 }}>
                <div className={styles.cardTitle}>{video.title}</div>
                <button
                  className={styles.downloadBtn}
                  onClick={() => downloadSong(video)}
                >
                  Download
                </button>
              </div>
            </div>
          ))
        )}
      </div>
    </div>
  );
}
