# require "lawn_mowing/version"
# require 'mower'

class String
  def is_integer?
    self.to_i.to_s == self
  end
end

module LawnMowing

  ##########################################
  # Mower
  ##########################################
  class Mower
    DIRECTIONS = ["S", "E", "N", "W"]
    attr_accessor :index, :x, :y, :direction, :moves

    def initialize(x, y, direction)
      @x = x.to_i
      @y = y.to_i 
      @direction = direction
      @index = nil
      @initial_x = @x 
      @initial_y = @y 
      @initial_direction = @direction

    end

    def moves_string
      self.moves.join("").chomp
    end

    def print_position_direction
      puts "#{@x} #{@y} #{@direction}"
    end

  end

  ##########################################
  # ManualMower
  ##########################################
  class ManualMower < Mower
    attr_accessor :x_temp, :y_temp, :index_movement, :number_tries

    def self.test(arg)
      puts "\n\n\n\n ------ test #{arg}\n\n\n\n"
    end
    def initialize(x, y, direction, moves = "")
      super(x, y, direction)
      @moves = moves.nil? ? [] : moves.split("")
      @index_movement = 0
      @number_tries = 0
    end

    def verify_position_inside_lawn?(x_temp, y_temp, lawn_x, lawn_y)
      return (x_temp >= 0 && x_temp <= lawn_x && y_temp >= 0 && y_temp <= lawn_y)
    end

    def current_movement
      self.moves[self.index_movement]
    end

    def do_turn(movement = nil)
      movement ||= current_movement
      dir = Mower::DIRECTIONS.index(@direction)
      if movement == "L" 
        dir = (dir == 3) ? 0 : dir + 1
      elsif movement == "R" 
        dir = (dir == 0) ? 3 : dir - 1
      end
      @direction = Mower::DIRECTIONS[dir]
      return true
    end

    def is_going_outside?(lawn_x, lawn_y)
      return (@current_movement == "M" || @current_movement.nil?) && (@x == 0 && @direction == "S" || @x == lawn_x && @direction == "N" || @y == 0 && @direction == "W" || @y == lawn_y && @direction == "E")
    end


    def do_move(lawn_mowers_positions = [], direction = nil)
      direction ||= @direction
      
      x_temp = @x 
      y_temp = @y
      if direction == "N" 
        y_temp +=  1  
      elsif direction == "E"
        x_temp += 1 
      elsif direction == "S"
        y_temp -= 1 
      elsif direction == "W"
        x_temp -= 1
      end

      fail = false
      lawn_mowers_positions.each_with_index do |position, ind|
        if ind == 0 
          unless verify_position_inside_lawn?(x_temp, y_temp, position[0], position[1])
            fail = true
          end
        else
          if (@index != ind - 1) && (x_temp == position[0] && y_temp == position[1])
            fail = true
          end
        end
      end

      if fail
        self.number_tries += 1
      else
        @x = x_temp
        @y = y_temp
        @index_movement += 1
        self.number_tries = 0
      end
      return fail
    end

    def do_action(lawn_mowers_positions = [])
      if current_movement == "M"
        return self.do_move(lawn_mowers_positions)
      else 
        result = self.do_turn
        self.index_movement += 1
        return result
      end
    end

    def set_moves(moves)
      @moves = moves.nil? ? [] : moves.split("")
    end

    def can_move?
      return self.number_tries < 10 && self.index_movement < @moves.size
    end

    def print_values
      puts "index:#{@index} ->x:#{@x}, y:#{@y}, direction:#{@direction}, moves:#{@moves}, number_tries:#{@number_tries}, index_movement:#{@index_movement}"
    end

    def print_output
      print_position_direction
    end

    def print_input
      puts "#{@initial_x} #{@initial_y} #{@initial_direction}"
      puts "#{@moves.join("").chomp}"
    end

    def print_current_output
      print_position_direction
      if !@index_movement.nil? && @index_movement < @moves.size && @number_tries < 10
        string = ""
        (0..@index_movement-1).each do |space|
          string << "_"
        end
        puts "#{string}\t@index_movement:#{@index_movement} number_tries:#{number_tries}"
      end 
      puts "#{@moves.join("").chomp}"
    end


  end

  ##########################################
  # AutomaticMower
  ##########################################
  class AutomaticMower < Mower

    attr_accessor :initial_x

    def initialize(x)
      super(x, 0, "N")
      @initial_x = x 
      @moves = []
      @index = 0
    end

    def add_move(move)
      @moves << move
    end

    def can_move?(lawn_mowers_positions = [])
      mowners_count = lawn_mowers_positions.count - 1
      return false if mowners_count <= 0

      lawn_x = lawn_mowers_positions[0][0]
      lawn_y = lawn_mowers_positions[0][1]

      return true if @y > 0 && @y < lawn_y

      x_position = 0
      if mowners_count == 1
        result = ( (@y == 0 || @y == lawn_y) && @x < lawn_x) || @x == lawn_x  && (@y > 0 && @direction == 'S' || @y < lawn_y && @direction == 'N') 
        return result
      elsif mowners_count > 1
        x_position = (mowners_count > 1) ? (lawn_x + 1) / mowners_count : 1
        if @index == mowners_count - 1
          return @x < lawn_x || @x == lawn_x && (@y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S')
        elsif (@x < (x_position * (@index + 1) - 1))
          return true
        else
          return (@y > 0 && @y < lawn_y) || @y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S'
        end
        return result
      end
      return false

      # puts "\nlawn_mowers_positions:#{lawn_mowers_positions}  lawn_mowers_positions.count:#{lawn_mowers_positions.count} x_position:#{x_position} = (#{lawn_x} + 1) / #{mowners_count }   x_position * (@index + 1)=#{x_position * (@index + 1)} "

      # puts "@y > 0 && @y < lawn_y || @y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S' || (@y == 0 && @direction == 'S' || @y == lawn_y && @direction == 'N') && ( @x < (x_position * (@index + 1)) || @x == lawn_x - 1)"
      # puts "#{@y > 0} && #{@y < lawn_y} || #{@y == 0} && #{@direction == 'N'} || #{@y == lawn_y} && #{@direction == 'S'} || (#{@y == 0} && #{@direction == 'S'} || #{@y == lawn_y} && #{@direction == 'N'}) &&  (#{@x < (x_position * (@index + 1))} || #{@x == lawn_x - 1})"
    
      # result = @y > 0 && @y < lawn_y || @y == 0 && @direction == 'N' || @y == lawn_y && @direction == 'S' || (@y == 0 && @direction == 'S' || @y == lawn_y && @direction == 'N') && ( @x < (x_position * (@index + 1) - 1) )
      # puts result
      # print_values
      # return result
    end

    def do_move(lawn_mowers_positions = [], direction = nil)

      return false unless can_move?(lawn_mowers_positions)
      direction ||= @direction
      
      x_temp = @x 
      y_temp = @y
      if direction == "N" 
        y_temp +=  1  
      elsif direction == "E"
        x_temp += 1 
      elsif direction == "S"
        y_temp -= 1 
      elsif direction == "W"
        x_temp -= 1
      end

      mowners_count = lawn_mowers_positions.count - 1
      return false if mowners_count <= 0

      lawn_x = lawn_mowers_positions[0][0]
      lawn_y = lawn_mowers_positions[0][1]

      x_position = (lawn_x + 1) / mowners_count 
      if (y_temp < 0 || y_temp > lawn_y)
        if @x < (x_position * (@index + 1)) && @x <= lawn_x
          if y_temp < 0
            @direction = "N"
            add_move("L")
            @x += 1
            add_move("M")
            add_move("L")
          else
            @direction = "S"
            add_move("R")
            @x += 1
            add_move("M")
            add_move("R")
          end
        else
          return false
        end
      else
        @x = x_temp
        @y = y_temp
        add_move("M")
      end
      return true
    end

    def do_action(lawn_mowers_positions = [])
      return self.do_move(lawn_mowers_positions)
    end

    def print_values
      puts "index:#{@index} ->initial_x:#{@initial_x}  x:#{@x}, y:#{@y}, direction:#{@direction}, moves:#{@moves}"
    end

    def print_initial_position_direction
      puts "#{@initial_x} 0 N"
    end
    def print_output
      print_initial_position_direction
      puts "#{@moves.join("").chomp}"
    end
  end


  ##########################################
  # MowingSystem
  ##########################################
  class MowingSystem
  	attr_accessor :lawn_x, :lawn_y, :mowers

  	def initialize(lawn_x = 0, lawn_y = 0)
  		@lawn_x, @lawn_y = lawn_x, lawn_y
  		@mowers = []
  	end

  	def self.read_file(file_name = nil)
  		string_list = []
	    if file_name.nil?
	      file_name = LawnMowing::ManualMowingSystem::FILE_NAME
	    end
	    unless File.exist?(file_name)
	    	file_name = Dir.getwd + "/" + file_name
	    end
	    if File.exist?(file_name)
	      file = File.open(file_name)
	      file.each {|line|
	      	string_list << line.chomp unless line.chomp.empty?
	      }
	    else
	      error = "File #{file_name} doesn't exist."
	      return error
	    end
	    return string_list
	  end


	  def self.init_run_system(file_or_array)
	  	if !file_or_array.nil? 
	  		if file_or_array.class == Array
	  			array_lines = file_or_array
	  		elsif file_or_array.class == String
	  			array_lines = read_file(file_or_array)
	  		end

	  		if array_lines.class == Array
	  			mowing_system = init(array_lines)
	  			unless 	mowing_system.class == String
	  				mowing_system.run_system
	  				return mowing_system
	  			else
	  				puts "#{mowing_system}"
	  				return mowing_system
	  			end
	  		else 
	  			puts "#{array_lines} "
	  			return "#{array_lines}"
	  		end
	  	end
	  end

  	def self.init(array_lines)
  		if array_lines.size > 1 && array_lines.size % 2 == 1
  			return ManualMowingSystem.init(array_lines)
  		elsif array_lines.size == 1
  			return AutomaticMowingSystem.init(array_lines)
  		else
  			return "Not valid sequence."
  		end
  	end

  	def set_lawn_dimensions(x, y)
  		@lawn_x, @lawn_y = x, y
  		@mowers = []
  	end

  	def add_mower(mower)
  		if mower.x >= 0 && mower.x <= @lawn_x && mower.y >= 0 && mower.y <= @lawn_y
	  		mower.index = @mowers.size
	  		@mowers << mower
	  	end
  	end


  	def lawn_mowers_positions
  		positions = []
  		positions << [@lawn_x, @lawn_y]
  		@mowers.each do |mower| 
  			positions << [mower.x, mower.y, mower.direction, mower.moves_string]
  		end
  		return positions
  	end

  	def run_system
  		while has_possible_moves
  			@mowers.each do |mower|
					mower.do_action(self.lawn_mowers_positions)
				end
  		end
  		puts "\n\nInput"
  		print_input
  		puts "\nOutput"
  		print_output
  	end

  	def print_values
  		puts "lawn_x: #{@lawn_x} lawn_y: #{@lawn_y}"
			@mowers.each do |mower|
				mower.print_output
			end
  	end 
  end


  ##########################################
  # ManualMowingSystem
  ##########################################
  class ManualMowingSystem < MowingSystem
  	ManualMowingSystem::FILE_NAME = 'manual_mowing.txt'

  	def self.is_valid?(array_lines)
  		return false if array_lines.size % 2 == 0
  		array_lines.each_with_index do |line, index|
				split_line = line.split(' ')
				if index == 0
					return false if split_line.size != 2
					return false unless split_line[0].is_integer? && split_line[1].is_integer?
				elsif index % 2 == 1  # 1, 3, 5   ex: 1 2 N, 3 3 E
					return false if split_line.size != 3
					return false unless split_line[0].is_integer? && split_line[1].is_integer?
					return false unless /^(N|S|E|W)$/.match(split_line[2])
				else # 2, 4, 5, 6, LMLMLMLMM, MMRMMRMRRM
					return false unless /^[LRM]*$/.match(line)
				end
			end
			true
  	end

  	def self.init(array_lines)
			return "Not valid sequence." unless is_valid?(array_lines)
			manual_mowing_system = ManualMowingSystem.new			
			mower = nil
			array_lines.each_with_index do |line, index|
				split_line = line.split(' ')
				if index == 0
					manual_mowing_system.set_lawn_dimensions(split_line[0].to_i, split_line[1].to_i)
				elsif index % 2 == 1  # 1, 3, 5   ex: 1 2 N, 3 3 E
					mower = ManualMower.new(split_line[0], split_line[1], split_line[2])
					if !manual_mowing_system.add_mower(mower)
						puts "Mower with dimensions (#{split_line[0]}, #{split_line[1]}) could not fit inside the lawn."
					end
				else # 2, 4, 5, 6, LMLMLMLMM, MMRMMRMRRM
					mower.set_moves(split_line[0]) unless mower.nil?
					mower = nil
				end
			end
			return manual_mowing_system
  	end

  	#if any mower can move
  	def has_possible_moves
  		@mowers.each do |mower|
  			return true if mower.can_move? && !mower.is_going_outside?(lawn_x, lawn_y)
	  	end
  		return false
  	end

  	def print_input 
  		puts "#{@lawn_x} #{@lawn_y}"
  		@mowers.each do |mower|
  			mower.print_input
  		end
  	end

  	def print_output
  		@mowers.each do |mower|
				mower.print_output
			end
  	end
  end

  ##########################################
  # AutomaticMowingSystem
  ##########################################
  class AutomaticMowingSystem < MowingSystem
  	AutomaticMowingSystem::FILE_NAME = 'automatic_mowing.txt'

  	def self.is_valid?(array_lines)
  		return false unless array_lines.size == 1
			split_line = array_lines[0].split(' ')
			return false if split_line.size != 3
			return false unless split_line[0].is_integer? && split_line[1].is_integer? && split_line[2].is_integer?
			true
  	end

  	def self.init(array_lines)
			return "Not valid sequence." unless is_valid?(array_lines)
			line = array_lines[0]
			split_line = line.split(' ')
			automatic_mowing_system = AutomaticMowingSystem.new(split_line[0].to_i, split_line[1].to_i)
			# automatic_mowing_system.set_lawn_dimensions(split_line[0].to_i, split_line[1].to_i)
			mower = nil
			x_position =  (automatic_mowing_system.lawn_x + 1) / split_line[2].to_i
			(0..split_line[2].to_i-1).each do |index|
				automatic_mowing_system.add_mower(AutomaticMower.new(x_position * index) )
			end
			return automatic_mowing_system
  	end

  	#if any mower can move
  	def has_possible_moves
  		@mowers.each do |mower|
  			return true if mower.can_move?(lawn_mowers_positions)
	  	end
  		return false
  	end

  	def print_input 
  		puts "#{@lawn_x} #{lawn_y} #{@mowers.count}"
  	end

  	def print_output
  		@mowers.each do |mower|
				mower.print_output
			end
  	end
  end
end
