namespace :db do
  desc "Drop, Create, and Migrate the db... Rebuild it from scratch!"
  task :bootstrap => [:drop, :create, :migrate]
end