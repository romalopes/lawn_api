require 'sinatra'
require 'sinatra/activerecord'
require './environments'
# require 'lawn_mowing'

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
    mowers = []
    mowers.each_with_index do |mower, index|
      local_map = {}
      local_map[:x] = mower.x
      local_map[:y] = mower.y
      local_map[:headings] = mower.headings
      local_map[:commands] = mower.commands
      mowers << local_map
    end
    map[:mower] = mowers
    map
  end

  def set_mowers_values(lawn_mowers_positions)
  	puts "\n\n\n\n-------- #{lawn_mowers_positions}  #{lawn_mowers_positions.count}-----"
  	mowers.each_with_index do |mower, index|
  		array = lawn_mowers_positions[index + 1]
  		puts "array:#{array}"
  		x = array[0]
  		y = array[1]
  		headings = array[2]
  		commands = array[3]

  		mower.update_attributes(x: x, y: y, headings: headings, commands: commands)
  	end
  end

  def execute
    array_list = self.array_positions
    mowing_system = LawnMowing::MowingSystem.init_run_system(array_list)
    if mowing_system.class != String
      lawn.set_mowers_values(mowing_system.lawn_mowers_positions)
      return lawn.map_positions
    else
      return mowing_system
    end
  end
end
