// src/components/Welcome.jsx
import React from 'react';
import { Link } from 'react-router-dom';

const Welcome = () => {
  return (
    <div className="pb-32 flex flex-col items-center justify-center min-h-screen bg-indigo-500">
      <div className="max-w-2xl w-full mx-auto flex flex-col items-center">
        <h1 className="font-bold text-7xl text-indigo-100 mb-4">Lalela</h1>
        <p className="text-lg text-gray-200 mb-8">Share your music with the world!</p>
        
        <div className="flex gap-4 flex-wrap justify-center">
          <Link 
            to="/search" 
            className="bg-purple-500 text-purple-100 p-2 rounded-lg w-32 text-center hover:bg-purple-600 transition-colors"
          >
            🔍 Search
          </Link>
          
          <Link 
            to="/library" 
            className="bg-green-500 text-green-100 p-2 rounded-lg w-32 text-center hover:bg-green-600 transition-colors"
          >
            📚 Library
          </Link>
        </div>
      </div>
    </div>
  );
};

export default Welcome;