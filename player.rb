# frozen_string_literal: true

require_relative 'character'
require_relative 'skills'

class Player < Character
  include Glue

  def initialize(**attributes)
    super(attributes)
    @@players << self
  end

  def refill_bolts
    @attributes.each do |e|
      e.refill_bolts if e.is_a? Skills
    end
  end
end
