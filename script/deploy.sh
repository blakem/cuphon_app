git push
git push heroku
echo "Heroku Done....."
git push beanstalk
dotcloud push cuphonapi.frontend .
# dotcloud run  cuphonapi.frontend 'cd code; rake db:migrate'
RAILS_ENV=test rake db:migrate
RAILS_ENV=development rake db:migrate
RAILS_ENV=production rake db:migrate
RAILS_ENV=localtest rake db:migrate