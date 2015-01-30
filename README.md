![General Assembly Logo](http://i.imgur.com/ke8USTq.png)

# Has Many Through (Albums, Songs, Artists)


## Objectives

By the end of this, students should be able to:

- Create a before_filter
- Add Model validations.
- Learn about Nested Resources.
- Practice creating one to many relationships.
- Learn about many to many relationships.


## Create an Albums resource

Create an Album resource. Album has a title and genre.  

```
rails g scaffold Album title:string genre:string
```

Migrate.  

```
rake db:migrate

```

Seed.  

```
Album.delete_all

nevermind = Album.create!(title: "Nevermind", genre: 'rock')
sea_change = Album.create!(title: "Sea Change", genre: 'jazz')

```

```
rake db:seed
```

## Before Action

Open up the Album controller and take a look at the before_action. 
A before action is run *before* actions, yep thats right. It does what it says! 

Here we are just removing duplicate code from the actions. Note how many actions,(show, edit, update and destroy), need to set the @album instance variable given an id from the params hash.  

[Rails Guide for Filters](http://guides.rubyonrails.org/action_controller_overview.html#filters)
[API Dock for before_filter](http://apidock.com/rails/ActionController/Filters/ClassMethods/before_filter)

Another very common use of a before filter is to check that a user is logged in. Or, as we'll see later, to set the outer resource when using nested resources.

## Create Model Validations

Validation are part of ActiveRecord. They prevent the creation of invalid models in the database. 

Add validations to the Album model.  

```
  #  defining a class constant named GENRES
  # Album::GENRES to access outside of the class
  GENRES = %w{rock rap country jazz ska dance}

  validates :title, presence: true
  validates :genre, inclusion: {in: GENRES}
```

This is creating two validations. The first will make sure that an album **without** a title can **not** exist. The second validation will make sure that the genre must be one of rock, rap, country, jazz, ska or dance.

Go ahead try to create an invalid Album in the rails console. *I dare ya*.

```
album = Album.new
album.save
```

Notice how the database transaction was **Rolled Back.** when we tried to save the album in the DB.    

Lets look at the errors.   
```
album.errors
```  
```
album.errors.full_messages
```

We'll see the that the title cant be blank and the genre is not valid. *Cool, huh*  
["Title can't be blank", "Genre is not included in the list"]


##### Try to create an invalid Album using the UI
How'd that happen? *Well, look at the form partial in app/views/albums/_form.html.erb*

```
<% if @album.errors.any? %>
    <div id="error_explanation">
      <h2><%= pluralize(@album.errors.count, "error") %> prohibited this album from being saved:</h2>

      <ul>
      <% @album.errors.full_messages.each do |message| %>
        <li><%= message %></li>
      <% end %>
      </ul>
    </div>
  <% end %>

```

Here's the magic to display errors!

This will display the number of errors and walk through the array of error messages.

#### Change the error message

In the album model.  

```
  validates :genre, inclusion: {in: GENRES, message: "is Invalid"}
```

#### Only allow the user to choose a valid genre.  

In the album form partial, use a select drop down for genre:  

```
 <%= f.select :genre,
    Album::GENRES,
    prompt: "Pick one" %>
```

## Create a nested resource for Songs.

Lets create a nested resource for songs. Another words, each song MUST be part of an album. We can **NEVER** access a Song without specifying it's containing Album.

Create a Song model.  

```
rails g model Song title:string artist:string duration:integer price:decimal album:belongs_to

rake db:migrate
```

Create some seed data for Songs.  

```
Song.delete_all
sea_change.songs.create!(title: 'golden age', artist: "beck", price: 1.99, dura\
tion: 215)
sea_change.songs.create!(title: 'lost Cause', artist: "beck", price: 4.99, dura\
tion: 182)
sea_change.songs.create!(title: 'lonesome Tears', artist: "beck", price: 2.99, \
duration: 156)

nevermind.songs.create!(title: 'lithium', artist: 'nirvana', duration: 193, pri\
ce: 1.99)
nevermind.songs.create!(title: 'come as you are', artist: 'nirvana', duration: \
177, price: 1.49)
```

Create a has_many in the Album model.   

```
  has_many :songs, dependent: :destroy

```

Seed the song data.  
```
rake db:seed
```

Take a look at each album and it's songs in the rails console.

## Create views for the Song nested resource.

In routes.rb  
```
resources :albums do
    resources :songs
end
```

This will create **Nested Routes**.   

```
rake routes
```

The route for each song has the id of the album that the song is part of.


```
class SongsController < ApplicationController

  def index
  	
    @album = Album.find(params[:album_id])
    @songs = @album.songs
  end
end
```

Get the id of the album that is in the URL's resource path and retrieve an Album from the DB.

Show ONLY the songs from this album.

in the Songs index view.  

```
 <h2><%= pluralize(@songs.count, 'song') %></h2>
 <ul>
  <% @songs.each do |song| %>
  <li><%= song.title %></li>
  <% end %>
 </ul>
```

## Create a new Song nested resource.

In the Songs controller.  

```
 def new
    @album = Album.find(params[:album_id])
    @song = @album.songs.new
  end

```

Create a new view.  

```
  <h1>Songs for Album <%= link_to(@album.title, album_path(@album)) %></h1>
  <%= render 'form' %>
```

Create a form partial for the Song resource.   

```
	<%= form_for [@album, @song] do |f| %>
	<%= render 'shared/errors', object: @song %>
	<p>
	  <%= f.label :title %>
	  <%= f.text_field :title, autofocus: true %>
	</p>
	<p>
	  <%= f.label :artist %>
	  <%= f.text_field :artist %>
	</p>
	<p>
	  <%= f.label :duration %>
	  <%= f.number_field :duration %>
	</p>
	<p>
	  <%= f.label :price %>
	  <%= f.text_field :price %>
	</p>

	<%= f.submit %>
	| <%= link_to "Cancel", albums_path %>
	<% end %>

```

Create a shared errors partial in app/views/shared/_errors.html.erb.   

```
	<% if object.errors.any? %>
	<div id="error_explanation">
	  <h2><%= pluralize(object.errors.count, "error") %> prohibited this object from being saved:</h2>

  <ul>
    <% object.errors.full_messages.each do |message| %>
    <li><%= message %></li>
    <% end %>
  </ul>
  </div>
 <% end %>
```

Create a create action in the Songs Controller.  

```
  def create
    @album = Album.find(params[:album_id])
    @song = @album.songs.new(songs_params)

    if @song.save
      redirect_to album_songs_path(@album)
    else
      render :new
    end
  end

  private

  def songs_params
    params.require(:song).permit(:title, :artist, :duration, :price)
  end

```


## Update the Flash
The flash is a hash structure that is used to display messages via the UI. It will only be avalaible for the next HTTP request.

[Rails flash](http://guides.rubyonrails.org/action_controller_overview.html#the-flash)

Add a notice to the UI that a song was created.

```

    if @song.save
      redirect_to album_songs_path(@album), notice: "You've created a new Song"
    else
      render :new
    end

```

The notice will set a key in the flash hash.   
flash[:notice] = "You've created a new Songs"

Show the flash in the layout.  

```
<% if flash[:notice].present? %>
  <p>
    <%= flash[:notice] %>
  </p>
<% end %>
```

## Create an Artist scaffold

```
rails g scaffold Artist name union_member:boolean dob:datetime
```

Now we have an Artist that can have a name and may be a union_member and has a Date of Birth.

By default the Artist will be a union member. *Add this to the Artist migraiton*  

```
     t.boolean :union_member, default: true
```

Migrate to add the artists table to the database.  
```
rake db:migrate
```

Create an artist in the rails console. And create, update and delete the Artist in the UI.

## Make a SongsArtist Join Table.

Now we are going to associate each Song not only with an Album, *remember each Song MUST be part of an album*, but each Song will be associated with **One or more Artists**. 

And each Artist MAY be associated with **One or more Songs.**

This is a **Many to Many** relationship between Songs and Artists. 



#### Create SongContribution model.

Create a **JOIN** model that will represent the **Many to Many** relationship between Songs and Artists.  

```
rails g migration CreateSongContribution song:belongs_to artist:belongs_to role:string
```

**Lets draw out the relationships as they will exist in the DB.**

Remove the artist field from Songs **because the this Artist to Song relationship will now be kept in the Join Table/Model.** *Don't forget to remove the artist attribute from the Song views.*  


```
rails g migration RemoveArtistFromSongs artist:string
```

Run the migrations. *May have to drop/create/migrate the DB*

```
rake db:migrate
```

Create a Join model for song contributions in app/models/song_contribution.rb  *Notice the namimg convention here*

```
class SongContribution < ActiveRecord::Base

  belongs_to :artist
  belongs_to :song

end

```

Add song contributions to the artist model.  ** We will use a through relationship to find the artist's songs!**

```
class Artist < ActiveRecord::Base

  has_many :song_contributions
  has_many :songs, through: :song_contributions
end

```

Add song contributions to the song model.  ** We will use a through relationship to find the song's artists!**

```
class Song < ActiveRecord::Base
  belongs_to :album

  has_many :song_contributions
  has_many :artists, through: :song_contributions
end
```

Add seed data.  

```
Album.delete_all

nevermind = Album.create!(title: "Nevermind", genre: 'rock')
sea_change = Album.create!(title: "Sea Change", genre: 'jazz')

golden_age = sea_change.songs.create!(title: 'golden age', price: 1.99, duration: 215)
lost_cause = sea_change.songs.create!(title: 'lost Cause', price: 4.99, duration: 182)
lonesome_tears = sea_change.songs.create!(title: 'lonesome Tears', price: 2.99, duration: 1\
56)

lithium = nevermind.songs.create!(title: 'lithium', duration: 193, price: 1.99)
come_as = nevermind.songs.create!(title: 'come as you are', duration: 177, price: 1.49)

Artist.delete_all
SongContribution.delete_all

kurt = Artist.create!(name: 'Kurt Cobain', dob: DateTime.parse("February 20, 1967") )
dave = Artist.create!(name: 'Dave Grohl', dob: DateTime.parse("January 14, 1969"))
beck = Artist.create!(name: 'Beck Hansen', dob: DateTime.parse("July 8, 1970"))

kurt.songs << lithium
kurt.songs << come_as

dave.songs << lithium

beck.songs << golden_age
beck.songs << lost_cause
beck.songs << lonesome_tears
```

#### In the Rails console.
- Take a look at each Artist's songs.
- Take a look at each Song's artists.

#### In the UI
- Take a look at each Artist's songs.
- Take a look at each Song's artists.

Oops, some work needs to be done here, ay!



