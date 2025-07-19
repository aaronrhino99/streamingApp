// src/Search.jsx
import { useState } from "react";

export default function Search() {
  const [query, setQuery] = useState("");
  const [results, setResults] = useState([]);

  const API = import.meta.env.VITE_API_BASE_URL || "http://localhost:3000/api/v1";

  const searchSongs = async () => {
    if (!query.trim()) return;
    try {
      const res = await fetch(`${API}/search?q=${encodeURIComponent(query)}`, {
        headers: { Authorization: `Bearer ${localStorage.getItem("authToken")}` },
      });
      if (!res.ok) throw new Error(`Server error: ${res.status}`);
      setResults(await res.json());
    } catch (err) {
      console.error("❌ Search failed:", err);
      alert("Error fetching search results—check console.");
    }
  };

  const downloadSong = async (video) => {
    try {
      const res = await fetch(`${API}/songs`, {
        method: "POST",
        headers: {
          "Content-Type": "application/json",
          Authorization: `Bearer ${localStorage.getItem("authToken")}`,
        },
        body: JSON.stringify({
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
    <div className="pb-32 flex flex-col items-center justify-start min-h-screen bg-indigo-500">
      <div className="max-w-2xl w-full mx-auto flex flex-col items-center space-y-6 pt-16">
        <h2 className="font-bold text-5xl text-indigo-100">🔍 Search YouTube</h2>
        <div className="w-full bg-white bg-opacity-90 p-6 rounded-lg shadow-lg space-y-4">
          <div className="flex">
            <input
              type="text"
              value={query}
              onChange={(e) => setQuery(e.target.value)}
              placeholder="Search for a song..."
              onKeyDown={(e) => e.key === "Enter" && searchSongs()}
              className="flex-1 px-4 py-2 border border-gray-300 rounded-l-lg focus:outline-none focus:ring-2 focus:ring-indigo-400"
            />
            <button
              onClick={searchSongs}
              className="bg-purple-500 text-purple-100 px-6 rounded-r-lg font-semibold hover:bg-purple-600 transition"
            >
              Search
            </button>
          </div>

          <div className="space-y-4">
            {results.length === 0 ? (
              <p className="text-gray-700 text-center">No results yet</p>
            ) : (
              results.map((video) => (
                <div
                  key={video.video_id}
                  className="flex items-center bg-white rounded-lg shadow p-4 space-x-4"
                >
                  <img
                    src={video.thumbnail_url}
                    alt={video.title}
                    className="w-24 h-24 rounded"
                  />
                  <div className="flex-1">
                    <div className="font-medium text-gray-800">{video.title}</div>
                  </div>
                  <button
                    onClick={() => downloadSong(video)}
                    className="bg-green-500 text-green-100 px-4 py-2 rounded-lg font-medium hover:bg-green-600 transition"
                  >
                    Download
                  </button>
                </div>
              ))
            )}
          </div>
        </div>
      </div>
    </div>
  );
}
