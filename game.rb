# frozen_string_literal: false

require_relative 'pnp.rb'

include PNP
using PNP

ina = player(
  name: 'Agnes',
  handeln: skills(
    reinigen: 34,
    elderly_elbows: 89
  ),

  wissen: skills(
    abfallmanagement: 74
  ),

  sozial: skills(
    theater: 74,
    oma_autorität: 84,
  )
)

neele = player(
  name: 'Hermann',

  handeln: skills(
    kneipenschlägerei: 73,
    handwerk: 82,
    dinge_abschießen: 32,
  ),

  wissen: skills(
    grasshüpfer: 73,
    chemische_waffen: 52
  ),

  sozial: skills(
    bier_trinken: 26,
    heftig_diskutieren: 87
  )
)

carlotta = player(
  name: 'Richard',

  handeln: skills(
    nähen: 63,
    desinfizieren: 29,
    diagnostik: 73
  ),

  wissen: skills(
    humanbiologie: 83,
    chemie: 29
  ),

  sozial: skills(
    dramatisieren: 39
  )
)

binding.irb
