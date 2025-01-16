# frozen_string_literal: true

require_relative 'dice'
require_relative 'npc'
require_relative 'player'
require_relative 'fight'

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

  def initiative(people)
    people
      .map { |character| [character.handeln + d10, character] }
      .sort_by! { |element| element[0] }
      .transpose[1]
      .reverse
  end

  def player(**attributes)
    Player.new(**attributes)
  end

  def npc(**attributes)
    Npc.new(**attributes)
  end

  def skills(sum = nil, **attributes)
    Skills.new(sum, **attributes)
  end

  def save_game(bnd, file_name)
    data = { players: [], npcs: [], vars: {} }

    bnd.local_variables.each do |var|
      value = bnd.local_variable_get(var)

      case value
      when Player
        data[:players] << value
        data[:vars][var] = [:players, data[:players].length - 1]
      when Npc
        data[:npcs] << value
        data[:vars][var] = [:npcs, data[:npcs].length - 1]
      end
    end

    File.open(file_name, 'w') do |fl|
      Marshal.dump(data, fl)
    end
  end

  def load_game(bnd, file_name)
    data = {}
    File.open(file_name) do |fl|
      data = Marshal.load(fl)
    end

    bnd.local_variable_set(:players, data[:players])
    bnd.local_variable_set(:npcs, data[:npcs])

    data[:vars].each_pair do |name, idx|
      bnd.local_variable_set(name.to_sym, data[idx[0].to_sym][idx[1]])
    end
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

  def check(number, dice = d100)
    number.check(dice)
  end
end
