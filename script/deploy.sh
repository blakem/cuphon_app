git push heroku
echo "Heroku Done....."
git push beanstalk
dotcloud push cuphonapi.frontend .

echo "You may need to 'dotcloud ssh cuphonapi.frontend     cd code; rake db:migrate; exit"