class Dict(D)
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
    return @entries[idx].definition
  end

  # Tries to retrieve a definition (`D`) from the entries, or returns `nil`
  def lookup?(word : String) : D?
    try{ lookup(word) }
  end

  # Uses binary search to locate the index of `word`, if it is present.
  # Otherwise returns nil
  private def index(word : String) : Int32?
    low, high = 0,  @entries.size
    return nil if low == high
    mid = high / 2

    while low <= high
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
  end

  # Uses binary search to locate the index where `word` should
  # be inserted so that the `@entries` is always sorted
  private def insertion_index(word : String) : Int32?
    high = @entries.size - 1
    low = 0

    while low < high
      mid = low + (high - low) / 2
      entry_word = @entries[mid].word

      case
      when entry_word == word
        return mid
      when entry_word < word
        low = mid + 1
        if @entries[low] > word
          return low
        end
      else # entry_word > word
        high = mid - 1
        if high == -1
          return 0
        elsif @entries[high] < word
          return mid
        end
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
