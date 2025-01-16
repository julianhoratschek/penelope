# frozen_string_literal: true

require_relative 'character'
require_relative 'skills'

class Player < Character
  include Glue

  def initialize(**attributes)
    super(attributes)
    @@players << self
  end
end
