# frozen_string_literal: true

require_relative 'character'
require_relative 'skills'

class Player < Character
  def initialize(**attributes)
    super(attributes)
  end
end
