# Load the rails application
require File.expand_path('../application', __FILE__)

# Initialize the rails application
CuphonApp::Application.initialize!

# Tell Mysql to use utf8
ActiveRecord::Base.connection.execute "SET collation_connection = 'utf8_general_ci' "