# frozen_string_literal: true

require_relative 'pnp'

include PNP
using PNP

players = [
  player(
    name: 'Agnes',
    alter: 58,
    handeln: skills(
      reinigen: 85,
      elderly_elbows: 85
    )
  ),
  player(
    name: 'Hermann',
    alter: 48,
    handeln: skills(
      dinge_abschießen: 50,
      handwerk: 85,
      kneipenschlägerei: 89
    ),
    wissen: skills(
      grasshüpfer: 40
    )
  ),
  player(
    name: 'Richard'
  )
]

goblin = Npc.new name: 'goblin', hp: 10, atk: 45, dmg: d6
enemies = goblin * 4


enemies.each do |e|
  puts e.name
  r = e.atk.ck
  if r.succ?
    dmg = e.dmg.roll
    dmg *= 2 if r.crit?
    puts "  Dmg: #{dmg}"
  else
    puts '  Failed'
  end
end

puts "D100: "
d100.history.each do |roll|
  print roll
  puts
end

d6.history.each do |roll|
  print roll
  puts
end
