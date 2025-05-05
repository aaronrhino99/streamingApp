Lalela Project
Lalela is a fun web app where you can search for YouTube music, save songs as MP3s, and listen to them in your browser. It has a Ruby on Rails backend and a React frontend.

What's benn done for

Backend Built: Rails API uses PostgreSQL to store users, songs, and playlists.
Sign Up & Login: You can create an account and log in with email and password.
YouTube Search: Find YouTube videos and see their title, artist, and picture.
MP3 Downloads: Turn YouTube videos into MP3s using a tool called yt-dlp, done in the background.
API Ready: The backend talks to the frontend with links for songs and playlists.
Frontend Started: React app is set up with basic pages and can connect to the backend(Almost finished).

Challenges

YouTube API Limits: We can only search YouTube a few times a day, or it stops working.
Tool Setup: Installing yt-dlp and ffmpeg on my Mac was hard because of missing instructions.
Background Jobs: Setting up Redis and Sidekiq took time, and jobs sometimes got stuck.
Frontend Connection: The React app having trouble talking to the backend because of something called CORS(Still ongoing)

What's Left

Search Page: Make a search bar to show YouTube songs and let users save them.
Music Player: Add a player to listen to MP3s with cool moving visuals.
Library Page: Show all saved songs so users can pick one to play.
Playlists: Let users create and manage lists of their favorite songs.
Make It Nice: Fix the app’s look, make it work on phones, and show messages if something goes wrong.
Test It: Try everything to find and fix problems.
Put It Online: Share the app so everyone can use it.

How to Run

Backend:
Clone: git clone lalela-api
Install: bundle install
Set up database: rails db:create && rails db:migrate
Start Redis: brew services start redis
Start Sidekiq: bundle exec sidekiq
Run: rails s


Frontend:
Clone: git clone lalela-client
Install: npm install
Run: npm run dev



You need ffmpeg, yt-dlp, and a YouTube API key in a .env file.

