echo; echo "************ RAILS_ENV=test rake db:migrate ."
RAILS_ENV=test rake db:migrate

echo; echo "************ RAILS_ENV=development rake db:migrate ."
RAILS_ENV=development rake db:migrate

echo; echo "************ RAILS_ENV=production rake db:migrate ."
RAILS_ENV=production rake db:migrate

echo; echo "************ RAILS_ENV=localtest rake db:migrate ."
RAILS_ENV=localtest rake db:migrate