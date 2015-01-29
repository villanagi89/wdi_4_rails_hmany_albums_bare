![General Assembly Logo](http://i.imgur.com/ke8USTq.png)

# Assignment Name (Ruby String Lab)

## Objectives

By the end of this, students should be able to:

- Create a before_filter
- Add Model validations.
- Learn about Nested Resources.
- Practice creating one to many relationships.
- Learn about many to many relationships.

## Instructions

### Create an Albums resource

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

#### Before Action

Open up the Album controller and take a look at the before_action. 
A before action is run *before* actions, yep thats right. It does what it says! 

Here we are just removing duplicate code from the actions. Note how many actions,(show, edit, update and destroy), need to set the @album instance variable given an id from the params hash.  

[Rails Guide for Filters](http://guides.rubyonrails.org/action_controller_overview.html#filters)
[API Dock for before_filter](http://apidock.com/rails/ActionController/Filters/ClassMethods/before_filter)

Another very common use of a before filter is to check that a user is logged in. Or, as we'll see later, to set the outer resource when using nested resources.

### Create Model Validations

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


## Bonus (Optional Section)

If you're looking for extra challenge or practice once you've completed the above, try to...

## Notes

Gotcha's and extra information

## Additional Resources

List additional related resources such as videos, blog posts and official documentation.

- Item 1
- Item 2
- Item 3
