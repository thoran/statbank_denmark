# Object/inQ.rb
# Object#in?

# 20250906
# 0.5.1

# Description: This is essentially the reverse of Enumerable#include?. It can be pointed at any object and takes a collection as an argument.

class Object

  def in?(*a)
    a.flatten.include?(self)
  end

end
