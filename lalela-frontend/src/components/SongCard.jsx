const SongCard = ({ song }) => {
  const handleDownload = async () => {
    const res = await fetch(`http://localhost:3000/songs/${song.id}/download`, {
      method: "POST",
      headers: {
        "Content-Type": "application/json",
        "access-token": localStorage.getItem("access-token"),
        client: localStorage.getItem("client"),
        uid: localStorage.getItem("uid"),
      }
    });

    if (res.ok) {
      alert("Download started");
    } else {
      alert("Failed to start download");
    }
  };

  return (
    <div className="song-card">
      <p>{song.title}</p>
      <button onClick={handleDownload}>Download</button>
    </div>
  );
};

export default SongCard;
