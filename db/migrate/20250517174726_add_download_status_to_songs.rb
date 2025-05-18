class AddDownloadStatusToSongs < ActiveRecord::Migration[8.0]
  def change
    add_column :songs, :download_status, :string, default: "pending"
    add_index :songs, :download_status
  end
end