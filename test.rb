# frozen_string_literal: false


def fun(**args)
  args.each_pair { |key, val|
    puts "#{key} #{val}"
  }
end

a = {:hello => "Hello", :world => "World"}
a => {hello:, world:}
puts "#{hello} #{world}"
