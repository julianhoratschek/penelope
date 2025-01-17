# frozen_string_literal: true

require_relative 'roll'


##
# Creates and throws dice with different sides
class Dice
  @instances ||= {}

  attr_reader :history

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

  ##
  # Check a new roll against other
  # @param other [Dice, Roll, Integer]
  # @return [Roll]
  def |(other)
    Roll.new(other.to_i, roll.to_i)
  end

  ##
  # Add a new roll to other
  # @param other [Integer, Dice, Roll]
  # @return [Roll]
  def +(other)
    roll + other.to_i
  end

  ##
  # Subtract other from a new roll
  # @param other [Integer, Dice, Roll]
  # @return [Roll]
  def -(other)
    roll - other.to_i
  end

  ##
  # Multiplicate other with a new roll
  # @param other [Integer, Dice, Roll]
  # @return [Roll]
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

  ##
  # Returns a new roll as an Integer
  # @return Integer
  def to_i
    roll.to_i
  end

  private

  ##
  # Do not call the constructor directly
  def initialize(sides = nil)
    @history = []
    @sides = sides || 20
  end
end
