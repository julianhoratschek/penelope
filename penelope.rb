# frozen_string_literal: true

require_relative 'dice'
require_relative 'npc'
require_relative 'player'
require_relative 'fight'

##
# Saving format for all relevant classes
class SaveFormat
  attr_reader :type, :index

  ##
  # Create a new SaveFormat instance
  # @param type [Symbol] Should be :players or :npcs
  # @param index [Integer] Index within according group
  def initialize(type, index)
    @type = type
    @index = index
  end
end

##
# Main module to catch all shortcuts
module Penelope
  ##
  # Stores local variables of toplevel scope after saving and loading
  @variables ||= {}

  class << self
    attr_reader :variables
  end

  ##
  # Sort value by its class for saving. Player, Npc and Array are supported.
  # @param value [Player, Npc, Array<Array, Player, Npc>] Value to store
  # @return [SaveFormat, Array<Array, SaveFormat>, nil]
  def _sort_by_type(value)
    case value
    when Player then SaveFormat.new(:players, Glue.players.index { |e| e.equal? value })
    when Npc then SaveFormat.new(:npcs, Glue.npcs.index { |e| e.equal? value })
    when Array then value.map { |e| _sort_by_type(e) }.compact!
    else nil
    end
  end

  ##
  # Load SaveValue and read it from already loaded Glue Data
  # @param where [SaveFormat, Array]
  # @return [Player, Npc, Array, nil]
  def _get_by_type(where)
    case where
    when SaveFormat
      case where.type
      when :players then Glue.players[where.index]
      when :npcs then Glue.npcs[where.index]
      else nil
      end
    when Array then where.map { |e| _get_by_type(e) }.compact!
    else nil
    end
  end

  private :_sort_by_type, :_get_by_type

  ##
  # Looks for d10, d20, d100 etc. formed methods and creates die with
  # the desired sides.
  def method_missing(name, *args)
    str_name = name.to_s
    return Dice.get str_name[1..].to_i if str_name.match?(/d\d+/i)

    if str_name[-1] == '='
      sym_name = str_name.chop.to_sym
      return Penelope.variables[sym_name] = args[0] if Penelope.variables.include? sym_name
    else
      return Penelope.variables[name] if Penelope.variables.include? name
    end

    super
  end

  def initiative(people)
    people
      .map { |character| [character.handeln + d10, character] }
      .sort_by! { |element| element[0] }
      .transpose[1]
      .reverse
  end

  ##
  # Get any Player or Npc by its name
  # @param name [String]
  # @return [Player, Npc]
  def get(name)
    Glue.find(name)
  end

  ##
  # List of all registered Players
  # @return [Array<Player>]
  def players
    Glue.players
  end

  ##
  # List of all registered Npc
  # @return [Array<Npc>]
  def npcs
    Glue.npcs
  end

  ##
  # Create and register a new player
  def player(**attributes)
    Player.new(**attributes)
  end

  ##
  # Create and register a new Npc
  def npc(**attributes)
    Npc.new(**attributes)
  end

  ##
  # Create a new Skills instance. Should be used within Player or Npc initializer
  def skills(sum = nil, **attributes)
    Skills.new(sum, **attributes)
  end

  ##
  # Save the current game state to file_name
  # @param bnd [Binding] Binding to save from
  # @param file_name [String] File to save game state to
  def save_game(bnd, file_name)
    data = {
      players: Glue.players,
      npcs: Glue.npcs,
      vars: {},
    }

    Penelope.variables.each_pair do |var_name, value|
      data[:vars][var_name] = _sort_by_type(value)
    end

    bnd.local_variables.each do |var_name|
      value = bnd.local_variable_get(var_name)
      data[:vars][var_name] = _sort_by_type(value)
    end

    data[:vars].delete(:_)

    File.open(file_name, 'w') do |fl|
      Marshal.dump(data, fl)
    end
  end

  ##
  # Load Game state from a file
  # @param file_name [String] Name of the file to load from
  def load_game(file_name)
    data = {}
    File.open(file_name) do |fl|
      data = Marshal.load(fl)
    end

    Glue.players = data[:players]
    Glue.npcs = data[:npcs]

    data[:vars].each_pair do |var_name, where|
      Penelope.variables[var_name] = _get_by_type(where)
    end
  end

  # ---------------------------------------------------------------

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
