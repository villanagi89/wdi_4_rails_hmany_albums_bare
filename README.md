![General Assembly Logo](http://i.imgur.com/ke8USTq.png)

# Assignment Name (Ruby String Lab)

## Objectives

By the end of this, students should be able to:

- Objective 1
- Objective 2
- Objective 3

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

Another very common use of a before filter is to check that a user is logged in.

Or, as we'll see later, to set the outer resource when using nested resources.


## Bonus (Optional Section)

If you're looking for extra challenge or practice once you've completed the above, try to...

## Notes

Gotcha's and extra information

## Additional Resources

List additional related resources such as videos, blog posts and official documentation.

- Item 1
- Item 2
- Item 3
