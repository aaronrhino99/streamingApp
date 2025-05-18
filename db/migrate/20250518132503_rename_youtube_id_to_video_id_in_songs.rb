class RenameYoutubeIdToVideoIdInSongs < ActiveRecord::Migration[8.0]
  def change
    rename_column :songs, :youtube_id, :video_id
  end
end
