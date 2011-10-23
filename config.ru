require './app.rb'
p "aaaaaaaaaaaaaa"
$stdout.sync = true
p "aaaaaaaaa"
run Sinatra::Application
