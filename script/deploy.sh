echo; echo "************ git push"
git push

echo; echo "************ git push heroku"
git push heroku
echo "Heroku Done....."

echo; echo "************ git push beanstalk"
git push beanstalk

echo; echo "************ dotcloud push cuphonapi.frontend ."
dotcloud push cuphonapi.frontend .

# dotcloud run  cuphonapi.frontend 'cd code; rake db:migrate'
script/migrate_all_databases.sh
