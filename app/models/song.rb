class Song < ActiveRecord::Base
  belongs_to :album

  has_many :artists_songs, class: ArtistsSongs
  has_many :artists, through: :artists_songs
end
