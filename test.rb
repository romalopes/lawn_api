ENV['RACK_ENV'] = 'test'
require 'minitest/autorun'
require 'rack/test'
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

describe "Lawn" do
  describe "GET /lawns" do
    before do
      # using the rack::test:methods, call into the sinatra app and request the following url
      get "/lawns"
    end

    it "responds successfully" do
      # Ensure the request we just made gives us a 200 status code
      last_response.status.must_equal 200
    end
  end
end