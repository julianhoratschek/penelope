# frozen_string_literal: false


class A
  def fn(a)
    print("A")
  end
end


module M
  refine A do
    def fn(a)
      if a.is_a? Integer
        print("M")
        return
      end
      super(a)
    end
  end
end


include M
using M

a = A.new()

print("B")

a.fn("A")
a.fn(8)
