# frozen_string_literal: true

##
# Holds information about one dice roll
class Roll
  attr_reader :value, :against

  ##
  # Update success and critical values
  def get_succ
    return if @against.nil?

    @success = @value <= @against
    @crit = @success ? @value <= @against / 10 : 100 - @against / 10 < @value
  end

  def initialize(value, against = nil)
    @value = value
    @against = against
    @success = nil
    @crit = nil

    get_succ
  end

  def *(other)
    @value *= other
    get_succ
    self
  end

  def +(other)
    @value += other
    get_succ
    self
  end

  def -(other)
    @value -= other
    get_succ
    self
  end

  def crit?
    @crit
  end

  def succ?
    @success
  end

  def fail?
    !@success
  end

  def to_s
    return @value.to_s if @against.nil?

    code = @success ? 112 : 160

    crit_msg = @crit ? "\e[38;5;160m󱈸 " : ''

    "#{crit_msg}\e[38;5;#{code}m #{@against} \e[38;5;#{code}m󰝮 #{@value}\e[0m"
  end

  def to_i
    @value
  end

  def inspect
    to_s
  end
end

##
# Creates and throws dice with different sides
class Dice
  @instances ||= {}

  attr_reader :history

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
    @history.push(Roll.new(rand(@sides) + 1, against)).last
  end

  def to_s
    roll.to_s
  end
end

##
# Main module to catch all shortcuts
module Penelope
  ##
  # Looks for d10, d20, d100 etc. formed methods and creates die with
  # the desired sides.
  def method_missing(name, *args)
    str_name = name.to_s
    return Dice.get str_name[1..].to_i if str_name.match?(/d\d+/i)

    super
  end

  refine Integer do
    ##
    # Tests this Integer versus a die-roll.
    # The output is printed in colors (red: fail, green: success)
    # Critical throws are marked with !!
    def check(dice = d100)
      dice_roll = dice.roll self
      puts dice_roll
      dice_roll
    end

    alias_method :ck, :check
  end
end

class Item
  # Quick create
  # Set name
  # Set nickname
  # write comments
  # who owns
  # add values

end

class Inventory

end

class Player
  # Quick create
  # set name
  # set nicknames
  # set action, wisdom, social
  # calculate values
  # inventory

  def initialize
  end

end

##
# Base Class to quickly create throw-away NPC for fights
class Npc
  @npc_count ||= {}

  ##
  # Add or access any attributes provided by the user
  def method_missing(name, *args)
    return @attributes[name.chop.to_sym] = args[0] if name[-1] == '='
    return @attributes[name] if @attributes.include? name

    super
  end

  ##
  # Keep track of how many instances of this NPC-prefab have been created, change name accordingly
  def self.count(attributes)
    name = attributes[:name]
    if @npc_count.include? name
      @npc_count[name] += 1
      attributes[:name] = "#{name} #{@npc_count[name]}"
    else
      @npc_count[name] = 0
    end
  end

  def initialize(attributes)
    Npc.count @attributes = { name: "npc", hp: 100, action: 5, knowledge: 5, social: 5 }.merge(attributes)

    super()
  end

  def rename(new_name)
    Npc.count @attributes[:name] = new_name
    self
  end

  def *(other)
    Array.new(other) { Npc.new(@attributes) }
  end
end


include Penelope
using Penelope

puts d50

players = Array.new(3) { Player.new }
ina, carlotta, neele = players

goblin = Npc.new name: 'goblin', hp: 10, atk: 45, dmg: d6
enemies = goblin * 4
enemies.each do |e|
  puts e.name
  r = e.atk.ck
  if r.succ?
    dmg = e.dmg.roll
    dmg *= 2 if r.crit?
    puts "  Dmg: #{dmg}"
  else
    puts '  Failed'
  end
end

puts "D100: "
d100.history.each do |roll|
  print roll
  puts
end

d6.history.each do |roll|
  print roll
  puts
end
