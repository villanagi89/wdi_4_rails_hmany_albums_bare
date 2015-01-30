class SongsController < ApplicationController

  def index
    @album = Album.find(params[:album_id])
    @songs = @album.songs
  end
end
