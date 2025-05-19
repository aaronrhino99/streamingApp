class CreateSongs < ActiveRecord::Migration[8.0]
  def change
    create_table :songs do |t|
      t.string  :youtube_id, null: false, index: { unique: true }
      t.string  :title
      t.string  :artist
      t.integer :duration
      t.integer :status, default: 0, null: false
      t.references :user, null: true, foreign_key: true
      t.timestamps
    end
  end
end
