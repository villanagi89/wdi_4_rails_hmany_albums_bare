class Album < ActiveRecord::Base
  #  defining a class constant named GENRES
  # Album::GENRES to access outside of the class
  GENRES = %w{rock rap country jazz ska dance}

  validates :title, presence: true
  validates :genre, inclusion: {in: GENRES, message: "is Invalid"}

  has_many :songs, dependent: :destroy
end
