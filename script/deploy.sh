git push
git push heroku
echo "Heroku Done....."
git push beanstalk
dotcloud push cuphonapi.frontend .
# dotcloud run  cuphonapi.frontend 'cd code; rake db:migrate'
script/migrate_all_databases.sh
