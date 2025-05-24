# 📓 Lalela App Development Log

**Date:** 2025-05-22  
**Developer:** Aaron  
**Stack:** Rails 8 API + React (Vite) + PostgreSQL + Devise Token Auth

---

## ✅ Project Overview

**Goal:** Build a full-stack music streaming and download app using YouTube as a source.  
**Key Features:** YouTube search, download to mp3, user authentication, playlist management, audio streaming.

---

## 🔐 Authentication Setup (Devise Token Auth)

- Installed `devise` and `devise_token_auth`
- Mounted route: `mount_devise_token_auth_for 'User', at: 'auth'`
- Configured CORS to allow frontend interaction
- Enabled token-based authentication for API-only use
- Added confirmable fields to `users` table (`confirmed_at`, `confirmation_token`, etc.)
- Set default confirm URL in initializer to skip frontend requirement
- Updated `ApplicationController` to skip `authenticate_user!` for Devise routes

---

## 🧪 CURL Tests

### ✅ Register a User
```bash
curl -X POST http://localhost:3000/auth \
  -H "Content-Type: application/json" \
  -d '{ 
    "email": "test@example1.com", 
    "password": "password123", 
    "password_confirmation": "password123", 
    "confirm_success_url": "http://localhost:5173" 
  }'
```

### ✅ Log In a User
```bash
curl -X POST http://localhost:3000/auth/sign_in \
  -H "Content-Type: application/json" \
  -d '{ 
    "email": "test@example1.com", 
    "password": "password123" 
  }'
```

---

## ✅ Git Commits Summary

```bash
git commit -m "Install and configure devise_token_auth for API authentication"
git commit -m "Add confirmable fields to users table for Devise compatibility"
git commit -m "Set default confirm_success_url in devise_token_auth initializer"
git commit -m "Allow unauthenticated access to DeviseTokenAuth routes in development"
```

---

## 🔜 Next Steps

- 🔒 Frontend login page with Axios
- 🎧 Protected endpoints (`/songs`, `/download`)
- 🧰 Use token headers in React requests
- 🗂 Implement YouTube search and background download job

---

Made with 💻 in ChatGPT.
