class Dict::Entry(D)
  include Comparable(Entry(D))
  include Comparable(String)

  getter word : String
  property definition : D

  def initialize(@word : String, @definition : D)
  end

  def <=>(other : Entry(D))
    @word <=> other.word
  end

  def <=>(other : String)
    @word <=> other
  end
end
