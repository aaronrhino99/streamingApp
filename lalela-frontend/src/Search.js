import React, { useState } from 'react';

export default function Search() {
  const [query, setQuery] = useState('');
  const [results, setResults] = useState([]);

  const handleSearch = async () => {
    const res = await fetch(`http://localhost:3000/search?q=${query}`);
    const data = await res.json();
    setResults(data);
  };

  return (
    <div>
      <input value={query} onChange={e => setQuery(e.target.value)} />
      <button onClick={handleSearch}>Search</button>
      <ul>
        {results.map((video, idx) => (
          <li key={idx}>
            <img src={video.thumbnail} alt={video.title} />
            <p>{video.title}</p>
          </li>
        ))}
      </ul>
    </div>
  );
}
