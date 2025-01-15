# frozen_string_literal: true

require_relative 'dice'
require_relative 'npc'

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
