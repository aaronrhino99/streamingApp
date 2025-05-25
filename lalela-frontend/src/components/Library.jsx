import { useState } from 'react'

export default function Search() {
  const [query, setQuery] = useState('')
  const [results, setResults] = useState([])

  const API = import.meta.env.VITE_API_BASE_URL

  const searchSongs = async () => {
    if (!query.trim()) return
    try {
      const res = await fetch(`${API}/search?q=${encodeURIComponent(query)}`)
      if (!res.ok) throw new Error('Search failed')
      const data = await res.json()
      setResults(data)
    } catch (err) {
      console.error(err)
      alert('Error fetching search results')
    }
  }

  const downloadSong = async (video) => {
    try {
      const res = await fetch(`${API}/songs`, {
        method: 'POST',
        headers: { 'Content-Type': 'application/json' },
        body: JSON.stringify({
          title: video.title,
          video_id: video.video_id,
          thumbnail_url: video.thumbnail_url
        }),
      })
      if (!res.ok) throw new Error('Download request failed')
      alert('Download started!')
    } catch (err) {
      console.error(err)
      alert('Error starting download')
    }
  }

  return (
    <div>
      <h2>🔍 Search YouTube</h2>
      <input
        value={query}
        onChange={e => setQuery(e.target.value)}
        placeholder="Search for a song…"
        onKeyDown={e => e.key === 'Enter' && searchSongs()}
      />
      <button onClick={searchSongs}>Search</button>

      <div style={{ marginTop: 20 }}>
        {results.map(video => (
          <div key={video.video_id} style={{ marginBottom: 16 }}>
            <img src={video.thumbnail_url} alt="" width={120} />
            <div>{video.title}</div>
            <button onClick={() => downloadSong(video)}>
              Download
            </button>
          </div>
        ))}
      </div>
    </div>
  )
}
