import { useState } from "react";

export default function Search() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);

  // Use Vite env var for API base
  const API = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000";

  const searchSongs = async () => {
    if (!query.trim()) return;
    try {
      const res = await fetch(`${API}/search?q=${encodeURIComponent(query)}`);
      if (!res.ok) throw new Error("Search failed");
      const data = await res.json();
      setResults(data);
    } catch (err) {
      console.error("Search error:", err);
      alert("Search failed");
    }
  };

  const downloadSong = async (video) => {
    try {
      const token = localStorage.getItem("jwt");
      const res = await fetch(`${API}/songs`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          "Authorization": `Bearer ${token}`
        },
        body: JSON.stringify({
          title: video.title,
          video_id: video.video_id,
          thumbnail_url: video.thumbnail_url
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
    <div style={{ padding: 20 }}>
      <h2>🔍 Search YouTube</h2>
      <div style={{ marginBottom: 12 }}>
        <input
          style={{ width: 300, padding: 8 }}
          type="text"
          value={query}
          onChange={(e) => setQuery(e.target.value)}
          placeholder="Search for a song…"
          onKeyDown={(e) => e.key === "Enter" && searchSongs()}
        />
        <button
          style={{ marginLeft: 8, padding: "8px 12px" }}
          onClick={searchSongs}
        >
          Search
        </button>
      </div>

      <div>
        {results.length === 0 ? (
          <p>No results yet</p>
        ) : (
          results.map((video) => (
            <div key={video.video_id} className="matrix-card">
              style={{
                display: "flex",
                alignItems: "center",
                marginBottom: 16,
              }}
            >
              <img
                src={video.thumbnail_url}
                alt={video.title}
                width={120}
                style={{ marginRight: 12 }}
              />
              <div style={{ flex: 1 }}>
                <div style={{ fontWeight: 500 }}>{video.title}</div>
                <button
                  style={{ marginTop: 4, padding: "4px 8px" }}
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