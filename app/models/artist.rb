class Artist < ActiveRecord::Base
  has_many :artists_songs, class: ArtistsSongs
  has_many :songs, through: :artists_songs
end
