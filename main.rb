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

class Player
  # Quick create
  # set name
  # set nicknames
  # set action, wisdom, social
  # calculate values
  # inventory

  def initialize
  end

end


include Penelope
using Penelope

puts d50

players = Array.new(3) { Player.new }
ina, carlotta, neele = players

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
