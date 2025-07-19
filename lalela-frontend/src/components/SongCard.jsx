import { downloadSong } from '../services/api';

function SongCard({ song, onDownloaded }) {
  const [loading, setLoading] = useState(false);

  const handleDownload = async () => {
    setLoading(true);
    try {
      const { data: newSong } = await downloadSong({
        title: song.title,
        artist: song.artist,
        youtube_id: song.youtubeId,
        thumbnail_url: song.thumbnailUrl,
      });
      // Notify parent that a new Song record exists
      onDownloaded(newSong);
    } catch (err) {
      console.error(err);
      alert('Download failed');
    } finally {
      setLoading(false);
    }
  };

  return (
    <div className="song-card">
      <img src={song.thumbnailUrl} alt="" />
      <h5>{song.title}</h5>
      <button onClick={handleDownload} disabled={loading}>
        {loading ? 'Processing...' : 'Download'}
      </button>
    </div>
  );
}
