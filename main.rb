# frozen_string_literal: true

require_relative 'penelope'

class Item
  # Quick create
  # Set name
  # Set nickname
  # write comments
  # who owns
  # add values

end

class Inventory

end

include Penelope
using Penelope

players = [
  Player.new(
    name: 'Agnes',
    alter: 58,
    handeln: Skills.new(
      reinigen: 85,
      elderly_elbows: 85
    )
  ),
  Player.new(
    name: 'Hermann',
    alter: 48,
    handeln: Skills.new(
      dinge_abschießen: 50,
      handwerk: 85,
      kneipenschlägerei: 89
    ),
    wissen: Skills.new(
      grasshüpfer: 40
    )
  ),
  Player.new(
    name: 'Richard'
  )
]

ina, neele, carlotta = players
puts neele

goblin = Npc.new name: 'goblin', hp: 10, atk: 45, dmg: d6
enemies = goblin * 4

print initiative(players + enemies)

return

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
