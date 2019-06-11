struct Dict::Entry(W, D)
  include Comparable(Entry(W, D))

  getter word : W
  property definition : D

  def initialize(@word : W, @definition : D)
  end

  def <=>(other : Entry(D))
    @word <=> other.word
  end
end
