class AddVideoIdToSongs < ActiveRecord::Migration[8.0]
  def change
    add_column :songs, :video_id, :string
  end
end
