// src/App.jsx
import { Routes, Route, Link } from "react-router-dom";
import Search from "./Search";
import Library from "./components/Library";

export default function App() {
  return (
    <div style={{ padding: 20 }}>
      <nav>
        <Link to="/search" style={{ marginRight: 10 }}>Search</Link>
        <Link to="/library">Library</Link>
      </nav>
      <Routes>
        <Route path="/" element={<h2>Welcome to Lalela!</h2>} />
        <Route path="search" element={<Search />} />
        <Route path="library" element={<Library />} />
      </Routes>
    </div>
  );
}
