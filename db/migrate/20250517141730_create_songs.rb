class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string :title
      t.string :artist
      t.integer :duration
      t.string :youtube_id
      t.string :thumbnail_url
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
