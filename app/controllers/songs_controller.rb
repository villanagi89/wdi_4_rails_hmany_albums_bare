class SongsController < ApplicationController

  def index
    @album = Album.find(params[:album_id])
    @songs = @album.songs
  end

  def show
    @album = Album.find(params[:album_id])
    @song = @album.songs.find(params[:id])
  end

  def new
    @album = Album.find(params[:album_id])
    @song = @album.songs.new
  end

  def create
    @album = Album.find(params[:album_id])
    @song = @album.songs.new(songs_params)

    if @song.save
      redirect_to album_songs_path(@album), notice: "You've created a new Song"
    else
      render :new
    end
  end

  private

  def songs_params
    params.require(:song).permit(:title, :artist, :duration, :price)
  end
end
