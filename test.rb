ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
# require './spec/spec_helper.rb'


require_relative 'api_lawn.rb'

include Rack::Test::Methods

def app
  Sinatra::Application
end

# describe "Test hello world" do

# def test_it_says_hello_world
#     get '/'
#     assert last_response.ok?
#     assert_equal 'Hello World', last_response.body
#   end

#   def test_it_says_hello_to_a_person
#     get '/', :name => 'Simon'
#     assert last_response.body.include?('Simon')
#   end

# end

describe "Lawns" do
  describe " /lawns" do
    # before do
    #   # using the rack::test:methods, call into the sinatra app and request the following url
    #   get "/lawns"
    # end

#     it "responds successfully" do
#       # Ensure the request we just made gives us a 200 status code
#       last_response.status.must_equal 200
#     end
#   end

#   describe "GET /lawns" do
#     before do
#       # using the rack::test:methods, call into the sinatra app and request the following url
#       get "/lawns"
#     end

#     it "responds successfully" do
#       # Ensure the request we just made gives us a 200 status code
#       last_response.status.must_equal 200
#     end

# 		it "/lawnsl GET" do
# 			Lawn.delete_all
# 		  Lawn.create(:width=>5, :height=>5)
# 		  Lawn.create(:width=>6, :height=>6)
# 		  get "/lawns"
# 		  last_response.status.must_equal 200
# 		  info = JSON::parse(last_response.body)
# 		  info.size.must_equal 2
# 		  info[0]["width"].must_equal 5
# 		  info[1]["width"].must_equal 6
# 		end  

# 		it "POST /lawn create" do
# 			Lawn.delete_all
# 		  Lawn.count.must_equal 0
# 		  post '/lawn', { lawn: {:width=>2, height: 1 } }
# 		 	last_response.status.must_equal 201
# 		  info = JSON::parse(last_response.body)
# 		  Lawn.count== 1
# 		  Lawn.first.width.must_equal 2
# 		end

# 		it "POST /lawn create with error" do
# 			Lawn.delete_all
# 		  Lawn.count.must_equal 0
# 		  post '/lawn', { :width=>2, height: nil }
# 		  Lawn.count.must_equal 0
# 		  last_response.status.must_equal 304
# 		end

# 		it "PUT /lawn/:id update" do
# 			Lawn.delete_all
# 		  lawn = Lawn.create(:width=>6, :height=>6)

# 		  params = {lawn:{:width=>2, height: 2 } }
# 		  put "/lawn/#{lawn.id}", params
# 		  Lawn.count.must_equal 1
# 		  Lawn.first.width.must_equal 2
# 		  Lawn.first.width.must_equal 2
# 		  last_response.status.must_equal 202
# 		  info = JSON::parse(last_response.body)
# 			info.size.must_equal 1
# 		  info["status"].must_equal "ok"
# 		end

# 		it "PUT /lawn/:id update Error" do
# 			Lawn.delete_all
# 		  lawn = Lawn.create(:width=>6, :height=>6)

# 		  params = {lawn:{:width=>2, height: nil } }
# 		  put "/lawn/#{lawn.id}", params
# 		  last_response.status.must_equal 304
# 		end

# ##############
# 		it "DELETE /lawn/:id delete" do
# 			Lawn.delete_all
# 		  lawn = Lawn.create(:width=>6, :height=>6)

# 		  params = { id: lawn.id }
# 		  delete "/lawn/#{lawn.id}", params
# 		 	last_response.status.must_equal 202
# 		  Lawn.count.must_equal 0
# 		  info = JSON::parse(last_response.body)
# 			info.size.must_equal 1
# 		  info["status"].must_equal "ok"
# 		end


# 		it "DELETE /lawn/:id/mower/:mower_id delete" do
# 			Lawn.delete_all
# 			Mower.delete_all
# 		  lawn = Lawn.create(:width=>6, :height=>6)
# 		  mower = lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
# 		  params = { id: lawn.id, mower_id: mower.id }
# 		  delete "/lawn/#{lawn.id}/mower/#{mower.id}", params
# 		  last_response.status.must_equal 202
# 		  Mower.count.must_equal 0
# 		  info = JSON::parse(last_response.body)
# 			info.size.must_equal 1
# 		  info["status"].must_equal "ok"
# 		end

		it "GET '/execute/:id'" do
			Lawn.delete_all
			Mower.delete_all
		  lawn = Lawn.create(:width=>5, :height=>5)
		  lawn.mowers.create(x:1, y:2, headings:"N", commands:"LMLMLMLMM")
		  lawn.mowers.create(x:3, y:3, headings:"E", commands:"MMRMMRMRRM")

		  get "/execute/#{lawn.id}", { id: lawn.id }
			last_response.status.must_equal 200
		  info = JSON::parse(last_response.body)
		  puts "info:#{info}"
		  Mower.first.x.must_equal 1
		  Mower.first.y.must_equal 3
		  Mower.first.headings.must_equal "N"
		  Mower.last.x.must_equal 5
		  Mower.last.y.must_equal 1
		  Mower.last.headings.must_equal "E"
		end
##############

		# it "/lawn/:id/mowers GET list all" do
		# 	Lawn.delete_all
		# 	Mower.delete_all
		#   lawn = Lawn.create(:width=>6, :height=>6)
		#   lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
		#   lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
		#   get "/lawn/#{lawn.id}/mowers"
		#   last_response.status.must_equal 200
		#   info = JSON::parse(last_response.body)
		#   info.size.must_equal 2
		#   info[0]["x"].must_equal 1
		#   info[1]["y"].must_equal 1
		# end  


		# it "POST /lawn/:id/mower create" do
		# 	Lawn.delete_all
		# 	Mower.delete_all
		# 	lawn = Lawn.create(:width=>6, :height=>6)
		#   lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
		#   Mower.count.must_equal 1
		#   post "/lawn/#{lawn.id}/mower", { id: lawn.id, mower: {x:2, y:2, headings:"N", commands:"MMMM" } }
		#   Mower.count.must_equal 2
		#   Mower.last.x.must_equal 2
		#   last_response.status.must_equal 201
		#   info = JSON::parse(last_response.body)
		#   info["x"].must_equal 2
		#   info["y"].must_equal 2
		# end

		# it "POST /lawn/:id/mower creat Error" do
		# 	Lawn.delete_all
		# 	Mower.delete_all

		# 	lawn = Lawn.create(:width=>6, :height=>6)
		#   lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
		#   Mower.count.must_equal 1
		#   post "/lawn/#{lawn.id}/mower", { id: lawn.id, mower: {x:nil, y:1, headings:"N", commands:"MMMM" } }
		#   Mower.count.must_equal 1
		#   last_response.status.must_equal 304
		# end

		# it "PUT /lawn/:id/mower/:mower_id update" do
		# 	Lawn.delete_all
		# 	Mower.delete_all

		# 	lawn = Lawn.create(:width=>6, :height=>6)
		#   mower = lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
		#   Mower.count.must_equal 1
		#   params = { id: lawn.id, mower_id: mower.id, mower: {x:2, y:1, headings:"S", commands:"MMMM"} }
		#   put "/lawn/#{lawn.id}/mower/#{mower.id}", params
		#   last_response.status.must_equal 202
		#   Mower.count.must_equal 1
		#   Mower.first.x.must_equal 2

		#   Mower.first.headings.must_equal "S"
		# end

		# it "DELETE /lawn/:id/mower/:mower_id delete" do
		# 	Lawn.delete_all
		# 	Mower.delete_all
		#   lawn = Lawn.create(:width=>6, :height=>6)
		#   mower = lawn.mowers.create(x:1, y:1, headings:"N", commands:"MMM")
		#   params = { id: lawn.id, mower_id: mower.id }
		#   delete "/lawn/#{lawn.id}/mower/#{mower.id}", params
		#   last_response.status.must_equal 202
		#   Mower.count.must_equal 0
		#   info = JSON::parse(last_response.body)
		# 	info.size.must_equal 1
		#   info["status"].must_equal "ok"
		# end
 	end
end