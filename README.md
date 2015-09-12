[![Codeship Status for leggsimon/instagram-challenge](https://codeship.com/projects/2cb54010-3160-0133-e0ee-0a744e9a501a/status?branch=master)](https://codeship.com/projects/99699)

[![Code Climate](https://codeclimate.com/github/leggsimon/instagram-challenge/badges/gpa.svg)](https://codeclimate.com/github/leggsimon/instagram-challenge)

[![Test Coverage](https://codeclimate.com/github/leggsimon/instagram-challenge/badges/coverage.svg)](https://codeclimate.com/github/leggsimon/instagram-challenge/coverage)

# Instagram Challenge

- [Approach](#approach)
- [How To Run](#how-to-run)
- [Design Principles Used](#design-principles-used)
- [Challenges](#challenges)
- [What I Have Learnt](#what-i-have-learnt)
- [Tests](#tests)
- [Technologies Used](#technologies-used)
- [Future Features](#future-features)

## Approach

Instagram Challenge was a task to create a RESTful Ruby-on-Rails CRUD application.
I started by allowing anyone to upload a picture and give it a description. Then I implemented the ability to be able to edit the description or delete the entire post. It was obvious after that that users would be needed in order to stop anyone being able to delete peoples posts.

I used the Devise gem for user authentication, adding the ability to login with usernames instead of email addresses and you would with the real Instagram.

Given some more time I would like to implement [more features](#future-features).

## How To Run


```
$ git clone https://github.com/leggsimon/instagram-challenge
$ cd instagram-challenge
$ gem install bundle
$ bundle install
$ bin/rake db:create RAILS_ENV=development
$ bin/rake db:create RAILS_ENV=test
$ bin/rake db:migrate RAILS_ENV=development
$ bin/rake db:migrate RAILS_ENV=test
```

##### To run the server:

```
$ rails s
```
Go to http://localhost:3000

##### To run the tests:
```
$ rspec
```

## Design Principles Used

I used a combination of Behavior Driven Design (BDD) and Test Driven Design (TDD) in this project, writing feature tests that covered a user's specific behavior when signing up and in and uploading, editing and deleting pictures. Using [Capybara's syntax](https://github.com/jnicklas/capybara#the-dsl) to be able to `click_link`s and `fill_in` forms as a user would when navigating the site.

## Challenges

The main challenge I had found with this was making the site scaleable with different sized screens,  but I finally figured out how to use Bootstrap's columns using the syntax,`.col-SIZE-8 .col-SIZE-offset-2`, within the tag's class. Where `SIZE` can be

- `xs` for extra small devices eg. phones
- `sm` for small devices eg. tablets
- `md` & `lg` for medium and large desktops

## What I Have Learnt

In order to check the `current_user` was able to update or destroy the post while at the same time keeping my controller skinny and doing minimal business logic in it, I created these methods in my `pictures.rb` model.

```ruby

# app/models/pictures.rb

def created_by?(user)
  self.user == user
end

def destroy_as(user)
  unless created_by? user
    errors.add(:user, 'cannot delete this picture')
    return false
  end
  destroy
end

def update_as(user, params)
  unless created_by? user
    errors.add(:user, 'cannot edit this picture')
    return false
  end
  update(params)
end
```

This allowed me to put the responsibility on the model to say whether the pictures were able to be updated or destroyed by the `current_user`.


```ruby

# app/controllers/pictures_controller.rb

def update
  picture = Picture.find(params[:id])
  if picture.update_as(current_user, picture_params)
    redirect_to picture_path
  else
    flash[:alert] = picture.errors
    redirect_to picture_path
  end
end

def destroy
  picture = Picture.find(params[:id])
  if picture.destroy_as current_user
    flash[:notice] = 'Picture deleted successfully'
    redirect_to pictures_path
  else
    flash[:alert] = picture.errors
    redirect_to picture_path
  end
end
```


## Tests

```
Commenting
  allows users to leave comments
  cannot leave a blank comment

Pictures
  no pictures have been added
    should display a prompt to upload a picture
  adding pictures
    is not valid with no description
  pictures have been added
    displays pictures
  viewing pictures
    lets a user view a picture
  when signed in a user can
    edit their picture's description
    delete their picture
  users cannot
    edit other users' pictures
    delete other users' pictures

User can sign in and out
  user not signed in and on the homepage
    should see a 'sign in' link and a 'sign up' link
    should not see 'sign out' link
  user signed in on the homepage
    should see 'sign out' link
    should not see a 'sign in' link and a 'sign up' link

Comment
  is invalid if the comment is blank

Picture
  should have many comments dependent => destroy
  should belong to user

User
  should have many pictures
```

## Technologies Used
- Backend
  - [Ruby](https://www.ruby-lang.org)
  - [Ruby on Rails](http://rubyonrails.org/)
  - [Devise](https://github.com/plataformatec/devise)
  - [Paperclip](https://github.com/thoughtbot/paperclip)
- Testing
  - [RSpec](https://relishapp.com/rspec)
  - [Capybara](https://github.com/jnicklas/capybara)
  - [Shoulda](https://github.com/thoughtbot/shoulda)
  - [Factory Girl](https://github.com/thoughtbot/factory_girl)
- Frontend
  - [HTML](http://www.w3schools.com/html/)
  - [CSS](http://www.w3schools.com/css/)
  - [Bootstrap](http://getbootstrap.com/)



## Future Features
Given more time I would like to implement the following features to this clone of Instagram.

- Social network login using [Omniauth](https://github.com/intridea/omniauth)
- Liking posts using [JQuery](http://jquery.com/) with AJAX
- Using [Amazon S3](https://aws.amazon.com/s3/) for storing images
- Tagging images & searching tags
