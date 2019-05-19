class Dict(D)
  class MissingEntry < Exception end

  getter entries = [] of Entry(D)

  def initialize
  end

  # See `#define`
  def []=(word : String, definition : D)
    define(word, definition)
  end

  # See `#lookup`
  def [](word : String)
    lookup(word)
  end

  # See `#lookup?`
  def []?(word : String)
    try{ lookup(word) }
  end

  # Rounds up all the definitions and returns them as an array
  def definitions : Array(D)
    @entries.map &.definition
  end

  # Rounds up all the words and returns them as an array
  def words : Array(String)
    @entries.map &.word
  end

  # Inserts a word to the dictionary for later `#lookup`
  def define(word : String, definition : D) : D
    idx = insertion_index(word)

    if idx
      if @entries[idx] == word
        @entries[idx].definition = definition
      else
        @entries.insert idx, Entry(D).new(word, definition)
        return definition
      end
    else
      @entries.push Entry(D).new(word, definition)
      return definition
    end
  end

  # Retrieves a definition (`D`) from the entries
  def lookup(word : String) : D
    idx = index(word)
    raise MissingEntry.new("undefined word `#{word}'") unless idx
    return @entries[idx].definition
  end

  # Tries to retrieve a definition (`D`) from the entries, or returns `nil`
  def lookup?(word : String) : D?
    try{ lookup(word) }
  end

  # Uses binary search to locate the index of `word`, if it is present.
  # Otherwise returns nil
  private def index(word : String) : Int32?
    low, high = 0, @entries.size - 1

    while low < high
      mid = low + (high - low) / 2
      entry_word = @entries[mid].word
      if entry_word == word
        return mid
      elsif entry_word < word
        low = mid + 1
      else
        high = mid - 1
      end
    end

    # if we escape the while loop, and low is the same as high
    # check if that index of `@entries` matches `word`
    # return low (or high) if it's a match
    return low if low == high && @entries[low].word == word
  end

  # Uses binary search to locate the index where `word` should
  # be inserted so that the `@entries` is always sorted
  private def insertion_index(word : String) : Int32?
    low, high = 0, @entries.size - 1

    while low < high
      mid = low + (high - low) / 2
      entry_word = @entries[mid].word
      if entry_word == word
        return mid
      elsif entry_word < word
        low = mid + 1
        return low if @entries[low] > word
      else
        high = mid - 1
        return 0 if high == - 1
        return mid if @entries[high] < word
      end
    end

    # if we skip the while loop, entries has only one element
    # if instead, mid was 1, high becomes 0
    #
    # in both cases, compare the first entry to `word`
    # return 0 if high == 0 && @entries[0] > word
    return 0 if high == 0 && @entries[0] > word
  end
end

require "./dict/entry"
