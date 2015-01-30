class Album < ActiveRecord::Base
  #DEFINE  a class constant that will have a list of  all the valid genres

  # It is a constant - your genres should be changed. It is a convention.
  GENRES = %W{ rock rap country jazz ska dance}

  validates :title, presence: true
  validates :genre, inclusion: {in: GENRES}
end

