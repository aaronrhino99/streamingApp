class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.references :user, null: false, foreign_key: true
      t.string :title
      t.string :artist
      t.string :youtube_id
      t.string :youtube_url
      t.integer :duration
      t.string :thumbnail_url
      t.integer :status
      t.text :error_message

      t.timestamps
    end
  end
end
