class Dict(W, D)
  class MissingEntry < Exception
  end

  include Enumerable({W,D})

  def each
    @entries.each{ |entry| yield entry.word, entry.definition }
  end

  @entries = [] of Entry(W, D)

  def initialize
  end

  protected def entries
   @entries
  end

  # See `#define`
  def []=(word : W, definition : D)
   define(word, definition)
  end

  # See `#lookup`
  def [](word : W)
   lookup(word)
  end

  # See `#lookup?`
  def []?(word : W)
   lookop?(word)
  end

  # Rounds up all the definitions and returns them as an array
  def definitions : Array(D)
   @entries.map &.definition
  end

  # Rounds up all the words and returns them as an array
  def words : Array(W)
   @entries.map &.word
  end

  # Inserts a word to the dictionary for later `#lookup`
  def define(word : W, definition : D) : D
   idx = insertion_index(word)

   entry = Entry(W,D).new word, definition

   if idx
     if @entries[idx].word == word
       @entries[idx] = entry
       return definition
     else
       @entries.insert idx, entry
       return definition
     end
   else
     @entries.push entry
     return definition
   end
  end

  # Retrieves a definition (`D`) from the entries
  def lookup(word : W) : D
   idx = index(word) || raise MissingEntry.new("undefined word `#{word}'")
   return @entries[idx].definition
  end

  # Tries to retrieve a definition (`D`) from the entries, or returns `nil`
  def lookup?(word : W) : D?
   idx = index(word) || return nil
   return @entries[idx].definition
  end

  def includes?(word : W) : Bool
   !!index(word)
  end

  # Uses binary search to locate the index of `word`, if it is present.
  # Otherwise returns nil
  private def index(word : W) : Int32?
   low, high = 0, @entries.size - 1

   while low < high
     mid = low + ((high - low) >> 1)
     midword = @entries[mid].word
     if midword == word
       return mid
     elsif midword < word
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
  private def insertion_index(word : W) : Int32?
    low, high = 0, @entries.size - 1

    while low < high
      mid = low + ((high - low) >> 1)
      midword = @entries[mid].word
      if midword == word
        return mid
      elsif midword < word
        low = mid + 1
        return low if @entries[low].word >= word
      else
        high = mid - 1
        return 0 if high == -1
        return mid if @entries[high].word <= word
      end
    end

    # if we skip the while loop, entries has only one element
    # if instead, mid was 1, high becomes 0
    #
    # in both cases, compare the first entry to `word`
    return 0 if high == 0 && @entries[0].word > word
  end
end

require "./dict/entry"
