if [ "$1" = "" ]; then
	comment="minor change for live test"
else
	comment="$@"
fi

git add .
git commit -m "$comment"
git push heroku
echo "Heroku Done....."
git push beanstalk
