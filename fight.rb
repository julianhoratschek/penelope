# frozen_string_literal: true


class Fight
  def initialize(people, &block)
    @people = people.map { |p| [p, []] }
    @turn = 1
    @last_turn = 1
    @counter = 1

    instance_eval &block
  end

  def next
    @people.rotate!(-1)
    @counter += 1
    if @counter > @people.size
      @turn += 1
      @last_turn = @turn > @last_turn ? @turn : @last_turn
      @counter = 1
    end

    if current[1].size <= @turn
      current[1] << 'No Action'
    end

    print " #{@turn} 󰓥 #{@counter}/#{@people.size}\n"
    print "   #{current_character.name} 󱞇 #{last_note}"
  end

  def back
    @people.rotate!(1)
    @counter -= 1
    return unless @counter <= 0 && @turn.positive?

    @turn -= 1
    @counter = @people.size

    print " #{@turn} 󰓥 #{@counter}/#{@people.size}\n"
    print "   #{current_character.name} 󱞇 #{last_note}\n"
  end

  def current
    @people[0]
  end

  def current_character
    current[0]
  end

  def history
    current[1].each_with_index do |note, i|
      puts "  %3i %s" % i, note
    end
  end

  def write(text)
    if @turn == @last_turn
      current[1] << text
    else
      current[1][@turn - 1] = text
    end
  end

  def last_note
    return current[1][@turn - 1] if @turn > 0
    'No Action'
  end

  alias cc current_character
  alias n next
  alias b back
  alias w write
  alias l last_note
  alias h history
end
