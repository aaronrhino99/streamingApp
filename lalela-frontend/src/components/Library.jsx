// src/components/Library.jsx

import React, { useState, useEffect } from 'react';
import AudioPlayer from './AudioPlayer';
import { getSongs, deleteSong } from '../services/api';

const Library = () => {
  const [songs, setSongs] = useState([]);
  const [loading, setLoading] = useState(true);
  const [currentSong, setCurrentSong] = useState(null);
  const [error, setError] = useState(null);

  useEffect(() => {
    fetchSongs();
  }, []);

  const fetchSongs = async () => {
    try {
      setLoading(true);
      const response = await getSongs();
      setSongs(response.data);
    } catch (err) {
      setError('Failed to load your library');
      console.error('Error fetching songs:', err);
    } finally {
      setLoading(false);
    }
  };

  const handlePlaySong = (song) => {
    if (song.status === 'ready') {
      setCurrentSong(song);
    }
  };

  const handleDeleteSong = async (songId) => {
    if (!window.confirm("Are you sure you want to delete this song?")) return;
    try {
      await deleteSong(songId);
      setSongs((prev) => prev.filter((s) => s.id !== songId));
    } catch (err) {
      console.error('Failed to delete song:', err);
      alert('Could not delete song. Please try again.');
    }
  };

  if (loading) {
    return (
      <div className="flex justify-center items-center h-64">
        <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-blue-500"></div>
      </div>
    );
  }

  if (error) {
    return (
      <div className="bg-red-100 border border-red-400 text-red-700 px-4 py-3 rounded">
        {error}
      </div>
    );
  }

  return (
    <div className="space-y-6">
      <div className="flex justify-between items-center">
        <h2 className="text-2xl font-bold">Your Library</h2>
        <button onClick={fetchSongs} className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600">
          REFRESH
        </button>
      </div>

      {songs.length === 0 ? (
        <div className="text-center py-12">
          <p className="text-gray-500 text-lg">No songs in your library yet.</p>
          <p className="text-gray-400">Search and download some songs to get started!</p>
        </div>
      ) : (
        <div className="grid gap-4 max-h-[80vh] overflow-y-auto scroll-smooth">
          {songs.map((song) => (
            <div
              key={song.id}
              className="bg-white rounded-lg shadow-md p-4 border border-gray-200 flex items-center justify-between"
            >
              <div className="flex-1 min-w-0">
                <h3 className="font-semibold text-lg truncate">{song.title}</h3>
                {song.artist && (
                  <p className="text-gray-600 truncate">{song.artist}</p>
                )}
                <div className="flex items-center space-x-4 mt-2">
                  <span className={`px-2 py-1 rounded text-xs ${
                    song.status === 'ready' 
                      ? 'bg-green-100 text-green-800' 
                      : 'bg-yellow-100 text-yellow-800'
                  }`}>
                    {song.status === 'ready' ? 'Ready' : 'Processing'}
                  </span>
                  {song.duration && (
                    <span className="text-gray-500 text-sm">
                      {Math.floor(song.duration / 60)}:{(song.duration % 60).toString().padStart(2, '0')}
                    </span>
                  )}
                </div>
              </div>

              <div className="flex items-center space-x-2">
                {song.status === 'ready' && (
                  <button
                    onClick={() => handlePlaySong(song)}
                    className="bg-blue-500 text-white px-4 py-2 rounded hover:bg-blue-600 flex items-center space-x-2"
                    aria-label={`Play ${song.title}`}
                  >
                    <span>Play</span>
                  </button>
                )}
                <button
                  onClick={() => handleDeleteSong(song.id)}
                  className="text-red-500 hover:text-red-700 px-2 py-1 rounded focus:outline-none"
                  aria-label={`Delete ${song.title}`}
                >
                  ×
                </button>
              </div>
            </div>
          ))}
        </div>
      )}

      {currentSong && (
        <AudioPlayer
          song={currentSong}
          onClose={() => setCurrentSong(null)}
        />
      )}
    </div>
  );
};

export default Library;
