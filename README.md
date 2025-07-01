# Lalela: My One-Week Music Streaming Adventure 🎶

Welcome to **Lalela**, a passion project born from curiosity and a desire to master modern web development. Over just one intense week, I built a fully functional music streaming MVP—powered by YouTube under the hood—and learned a ton along the way.

---

## 🚀 Why I Built Lalela

* **Hands-On Learning**: Every line of code was a chance to try something new, from authentication to audio streaming.
* **Full-Stack Fun**: I wanted to connect the dots between a Rails API backend and a React frontend (plus everything in between!).
* **Audio Magic**: Extracting YouTube audio, converting it to MP3, and playing it back in the browser? That was the ultimate playground.

---

## 🛠️ Technologies & Tools

### 🔧 Backend

* ✅ **Ruby on Rails (v8.0.2)** — API-centric with PostgreSQL
* ✅ **Devise & JWT** — Secure sign-up, login, and token revocation
* ✅ **Sidekiq & Redis** — Background jobs for heavy-lifting tasks
* ✅ **Active Storage** — File uploads & streaming
* ✅ **yt-dlp & FFmpeg** — YouTube audio extraction and MP3 conversion
* ✅ **YouTube Data API v3** — Searching videos by keyword
* ✅ **Rack::CORS** — Smooth cross-origin communication

### 🎨 Frontend

* ✅ **Vite + React v18** — Lightning-fast dev server and hooks-based UI
* ✅ **React Router v6** — Client-side routing and protected pages
* ✅ **react-youtube** — Instant in-app YouTube embeds
* ✅ **Howler.js** — Robust audio playback controls
* ✅ **Canvas (Digital Rain)** — Matrix-style background for flair
* ✅ **Custom CSS** — Neon-green on black, monospaced terminal vibe

### 🚀 Dev & Ops

* ✅ **Docker & Docker Compose** — Containerized Postgres, Redis, Rails, Sidekiq
* ✅ **Foreman / Procfile** — Local process orchestration
* ✅ **Git & GitHub** — Feature branches, clear commit history, PRs

---

## 🌐 What I Explored

1. **Authentication & Security** — Devise, JWT tokens, protecting endpoints
2. **Background Jobs** — Offloading work (YouTube downloads + conversion) to Sidekiq
3. **RESTful API Design** — Search, song management, playlists (soon!)
4. **CORS** — Letting React and Rails talk to each other
5. **React State & Effects** — Fetching data and updating the UI dynamically
6. **Audio Streaming** — Serving MP3s and controlling playback with Howler
7. **Embedded Media** — Wrapping YouTube iframes in React components
8. **Real-Time UX** *(coming soon)* — Notifications or WebSockets for download completion
9. **Visual Theming** — Canvas animations and neon styling for a “Matrix” feel
10. **Containerization** — Docker tips and Procfile magic for local dev

---

## 📁 Project Structure

```bash
lalela-api/             # Rails API backend
├─ app/                  # Controllers, models, services, jobs
├─ config/               # Routes, initializers (CORS, Devise, Sidekiq)
├─ db/                   # Migrations & schema
├─ storage/              # Active Storage files
├─ Dockerfile            # Rails container setup
├─ docker-compose.yml    # Dev environment: Postgres, Redis, Rails, Sidekiq
└─ Procfile              # Foreman processes

lalela-frontend/        # Vite + React frontend
├─ public/               # Static assets & index.html
├─ src/                  # Components, hooks, pages, styles
│   ├─ components/       # Library, DigitalRain, etc.
│   ├─ hooks/            # useHowl, etc.
│   ├─ App.jsx
│   ├─ main.jsx
│   └─ index.css         # Matrix-themed styles
└─ vite.config.js        # Vite configuration
```

---

## 🎯 What’s Next

* ⚠️ **Playlists UI**: Building the interface to create and manage playlists
* ⚠️ **Real-Time Notifications**: Let users know when their tracks are ready
* ⚠️ **Testing**: Adding RSpec & Jest/RTL tests to ensure everything works
* ⚠️ **CI/CD & Deployment**: Setting up GitHub Actions and deployment scripts

---

Thanks for stopping by! I made Lalela as a sandbox for exploration—feel free to browse the code, peek at the branches, and enjoy the ride. 🚀
