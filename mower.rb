require 'sinatra'
require 'sinatra/activerecord'
require './environments'

class Mower < ActiveRecord::Base
  belongs_to :lawn, dependent: :destroy

  validates_presence_of :x, :y, :headings, :commands
  validates :x, numericality: { only_integer: true }
  validates :y, numericality: { only_integer: true }

  validate :all_validations
  def all_validations
  	unless headings.nil? || /^(N|S|E|W)$/.match(headings) 
  		errors.add(:headings, "Headings is invalid.  It should be S, E, N or W")
  	end
  	unless commands.nil? || /^[LRM]*$/.match(commands)
  		errors.add(:commands, "Commands is invalid.  It should be M, L or R")
  	end
  end
end