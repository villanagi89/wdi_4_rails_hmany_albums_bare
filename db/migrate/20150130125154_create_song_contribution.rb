class CreateSongContribution < ActiveRecord::Migration
  def change
    create_table :song_contributions do |t|
      t.belongs_to :song, index: true
      t.belongs_to :artist, index: true
      t.string :role
    end
    add_foreign_key :song_contributions, :songs
    add_foreign_key :song_contributions, :artists
  end
end
