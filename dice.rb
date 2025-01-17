# frozen_string_literal: true

require_relative 'roll'


##
# Creates and throws dice with different sides
class Dice
  @instances ||= {}

  attr_reader :history
  private :initialize

  ##
  # Do not call the constructor directly
  def initialize(sides = nil)
    @history = []
    @sides = sides || 20
  end

  ##
  # Searches for existing instances or creates a new one
  def self.get(sides = nil)
    if sides && @instances.include?(sides)
      @instances[sides]
    else
      @instances[sides] = Dice.new sides
    end
  end

  ##
  # Create a new Roll instance and save it in this dices history
  def roll(against = nil)
    @history.push(Roll.new(rand(@sides) + 1, against&.to_i)).last
  end

  def |(other)
    Roll.new(other.to_i, roll.to_i)
  end

  def +(other)
    roll + other.to_i
  end

  def -(other)
    roll - other.to_i
  end

  def *(other)
    roll * other.to_i
  end

  ##
  # Dice does not really provide an interface, so coerce returns two Roll instances
  # @return [Roll]
  def coerce(other)
    [Roll.new(other, nil), roll]
  end

  def to_s
    roll.to_s
  end

  def inspect
    roll.inspect
  end

  def to_i
    roll.to_i
  end
end
