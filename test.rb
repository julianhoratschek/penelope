# frozen_string_literal: false

require_relative 'penelope'

include Penelope
using Penelope


ina = player(name: "Agnes", handeln: skills(
  reinigen: 50,
  ellenbogen: 93
))

save_game binding, 'save.game'
