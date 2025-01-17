# frozen_string_literal: true

require_relative 'character'
require_relative 'skills'

class Player < Character
  include Glue

  def initialize(**attributes)
    raise 'Spieler müssen einen Namen zugewiesen bekommen' unless attributes.include? :name

    super(attributes)
    @@players << self
  end

  ##
  # Reset all bolts of this player to maximum.
  def refill_bolts
    @attributes.each do |e|
      e.refill_bolts if e.is_a? Skills
    end
  end
end
