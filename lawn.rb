require 'sinatra'
require 'sinatra/activerecord'
require './environments'
# require './lawn_mowing/lawn_mowing.rb'
require './lawn_mowing/lawn_mowing'

class Lawn < ActiveRecord::Base
	has_many :mowers

  validates_presence_of :width, :height
  validates :width, numericality: { only_integer: true }
  validates :height, numericality: { only_integer: true }

  def to_s
  	return "id:#{id} width:#{width} height:#{height} mower count:#{mowers.count}"
  end

  def array_positions 
  	array = []
  	array << "#{self.width} #{self.height}"
  	mowers.each_with_index do |mower, index|
  		array << "#{mower.x} #{mower.y} #{mower.headings}"
  		array << "#{mower.commands}"
  	end
  	array
  end

  def map_positions
    map = {}
    map[:width] = self.width
    map[:height] =  self.height
    mowers_array = []
    mowers.each_with_index do |mower, index|
      local_map = {}
      local_map[:x] = mower.x
      local_map[:y] = mower.y
      local_map[:headings] = mower.headings
      local_map[:commands] = mower.commands
      mowers_array << local_map
    end
    map[:mower] = mowers_array
    map
  end

  def set_mowers_values(lawn_mowers_positions)
  	mowers.each_with_index do |mower, index|
  		array = lawn_mowers_positions[index + 1]
  		x = array[0]
  		y = array[1]
  		headings = array[2]
  		commands = array[3]
  		mower.update_attributes(x: x, y: y, headings: headings, commands: commands)
  	end
  end

  def execute
    begin
      array_list = self.array_positions
      mowing_system = LawnMowing::MowingSystem.init_run_system(array_list)
      if mowing_system.class != String
        self.set_mowers_values(mowing_system.lawn_mowers_positions)
        self.reload

        return self.map_positions
      else
        return mowing_system
      end
    rescue => e 
      puts "Error: #{e}"
      return e
    end
  end
end
