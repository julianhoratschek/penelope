# frozen_string_literal: false

module M
  @@test = []
end

class C
  include M

  def initialize(name)
    @@test << name
  end

  def test
    @@test
  end
end

class A
  include M

  def initialize(name)
    @@test << name
  end
end


a = C.new(1)
b = C.new(2)
c = C.new(3)
d = A.new(4)
e = A.new(5)
f = A.new(6)

puts c.test
