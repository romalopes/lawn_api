API REST that manage lawns and mower and call manual mowing system returning Json values.

GitHub
  https://github.com/romalopes/lawn_api
Travis
  https://travis-ci.org/romalopes/lawn_api
Heroku
  http://lawn-api.herokuapp.com/  (not working yet)


To run locally:
 $ git clone   https://github.com/romalopes/lawn_api.git
 $ cd lawn_api
 $ bundle install

 # To test
  	$ bundle exec ruby test.rb

 # To run the api web server
  	$ bundle exec ruby api_lawn.rb

http://localhost:4567/renew_data_base
http://localhost:4567/execute/:id