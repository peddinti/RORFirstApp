namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    create_users
    create_microposts
    create_relationships
  end
end

def create_users
  User.create!(name: "Example User",
               email: "example@railstutorial.org",
               password: "foobar",
               password_confirmation: "foobar")
  99.times do |n|
    name  = Faker::Name.name
    email = "example-#{n+1}@railstutorial.org"
    password  = "password"
    User.create!(name: name,
                 email: email,
                 password: password,
                 password_confirmation: password)
  end
end

def create_microposts
  # creating sample posts now
  users = User.all(limit: 6)
  50.times do |n|
    content = Faker::Lorem.sentence(5)
    users.each {|user| user.microposts.create!(content: content)}
  end
end

def create_relationships
  users = User.all
  user = users.first
  following_users = users[1..40]
  followed_users = users[10..50]
  following_users.each {|following_user| user.follow!(following_user)}
  followed_users.each {|followed_user| followed_user.follow!(user)}
end