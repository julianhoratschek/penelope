# frozen_string_literal: true

class Roll
  attr_reader :value, :against, :success, :crit

  def initialize(value, against = 0)
    @value = value
    @against = against

    @success = against != 0 ? value <= against : nil
    @crit = @success ? value <= against / 10 : 100 - against / 10 < value
  end

  def is_crit?; @crit end
  def is_succ?; @success end
  def is_fail?; !@success end
end

# Creates and throws dice with different sides
class Dice
  @instances ||= {}

  attr_reader :history

  def self.get(sides = nil)
    if sides && @instances.include?(sides)
      @instances[sides]
    else
      @instances[sides] = Dice.new sides
    end
  end

  def initialize(sides = nil)
    @history = []
    @sides = sides || 20
  end

  def roll
    @history.push(rand(@sides) + 1)[-1]
  end

  def to_s; roll.to_s end

  def to_i; roll end
end


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
      dice_roll = dice.roll

      if dice_roll <= self
        crit = dice_roll <= self / 10
        code = 112
      else
        crit = 100 - self / 10 < dice_roll
        code = 160
      end

      print "\e[38;5;160m\u203c " if crit
      puts "\e[38;5;#{code}m #{self} \e[38;5;#{code}m\u2684 #{dice_roll}\e[0m"
    end

    alias ck check
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

class Npc
  @npc_count ||= {}

  def method_missing(name, *args)
    return @attributes[name.chop.to_sym] = args[0] if name[-1] == '='
    return @attributes[name] if @attributes.include? name

    super
  end

  private

  def self.count(attributes)
    name = attributes[:name]
    if @npc_count.include? name
      @npc_count[name] += 1
      attributes[:name] = "#{name} #{@npc_count[name]}"
    else
      @npc_count[name] = 0
    end
  end

  public

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

players = Array.new(3) { Player.new }
ina, carlotta, neele = players

goblin = Npc.new name: 'goblin', hp: 10, atk: 45, dmg: d6
enemies = goblin * 4
enemies.each do |e|
  puts e.name
  e.atk.ck
end
