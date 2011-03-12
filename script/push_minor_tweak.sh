if [ "$1" = "" ]; then
	comment="minor change for live test"
else
	comment="$@"
fi

git add .
git commit -m "$comment"
script/deploy.sh
