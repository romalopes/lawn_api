require 'sinatra'
require 'json'
require 'sinatra/activerecord'
require './environments'
require './lawn'
require './mower'

get "/renew_data_base" do 
  Lawn.delete_all
  Mower.delete_all
  lawn = Lawn.create(:width=>5, :height=>5)
  lawn.mowers.create(x:1, y:2, headings:"N", commands:"LMLMLMLMM")
  lawn.mowers.create(x:3, y:3, headings:"E", commands:"MMRMMRMRRM")

  status 200
  return { status: "ok", lawns: Lawn.all.to_json, mowers: Mower.all.to_json}.to_json
end

get "/" do
  Lawn.all.to_json
end

# list all
get '/lawns' do
  Lawn.all.to_json
end

# view one
get '/lawn/:id' do
  lawn = Lawn.find(params[:id])
  return status 404 if lawn.nil?
  lawn.to_json
end

# create
post '/lawn' do

  lawn = Lawn.new(params[:lawn])
  if lawn.save
    status 201
    lawn.to_json
  else
    status 304
  end
end

# update
put '/lawn/:id' do
  lawn = Lawn.find(params[:id])

  return status 404 if lawn.nil?
  lawn.update(params[:lawn])
  if lawn.save
    status 202
    return { status: "ok" }.to_json
  else
    status 304
  end
end

delete '/lawn/:id' do
  lawn = Lawn.find(params[:id])
  return status 404 if lawn.nil?
  lawn.delete
  status 202
  return { status: "ok" }.to_json
end

get '/execute/:id' do
		lawn = Lawn.find(params[:id])
		result = lawn.execute
    status 200
		result.to_json
end





# list all
get '/lawn/:id/mowers' do
  Mower.all.to_json
end

# view one
get '/lawn/:id/mower/:mower_id' do
  lawn = Lawn.find(params[:id])
  mower = lawn.find(params[:mower_id])
  return status 404 if lawn.nil?
  mower.to_json
end

# create
post '/lawn/:id/mower' do
  lawn = Lawn.find(params[:id])
	return status 404 if lawn.nil?
	mower = Mower.new(params[:mower])

  if mower.save
    lawn.mowers << mower
    status 201
    mower.to_json
  else
    status 304
  end
end

# update
put '/lawn/:id/mower/:mower_id' do
	lawn = Lawn.find(params[:id])
	return status 404 if lawn.nil?
  mower = lawn.mowers.find(params[:mower_id])
  return status 404 if mower.nil?
  if mower.update(params[:mower])
    status 202
    return { status: "ok" }.to_json
  else	
    status 304
    mower.errors.to_json
  end
end

#delete
delete '/lawn/:id/mower/:mower_id' do
  lawn = Lawn.find(params[:id])
  return status 404 if lawn.nil?
  mower = lawn.mowers.find(params[:mower_id])
  mower.delete
  status 202
  return { status: "ok" }.to_json
end
