# Dict

[![Build Status](https://travis-ci.org/galvertez/dict.cr.svg?branch=master)](https://travis-ci.org/galvertez/dict.cr)

Dict is a hash-like type for crystal-lang. It uses binary search for lookups and insertion to ensure that the entries are always sorted. This means its performance on either of those operations will often be slightly worse than `Hash(K,V)`. That being said, insertion of a scrambled array of 100,000 `Int32` takes only half a second on my local machine, so it's still not too bad - I guess you just can't make crystal slow. However, inserting a scrambled array of 1,000,000 `Int32` took nearly 85 seconds for `Dict` but took only half a second for `Hash`, so there is almost certainly some opportunity for optimization there - maybe you can make crystal slow after all. Lookups on the same data set was almost the same for both.

Where `Dict(W,D)` comes out ahead is with huge data sets, where repeated enumeration of a sorted list of elements is necessary. Since the effort of sorting the elements is frontloaded to the time of insertion, there is no need to ever manually sort the dictionary. In fact, `Dict(W,D)` doesn't even have a `#sort` method - it's a given!

In my testing of dict vs hash, I found that, compared to sorting a `Hash`'s keys, `Dict` being pre-sorted usually more than makes up for the performance penalty paid during insertion, just on the first pass.

All in all, `Dict(W,D)`'s use case is probably niche at best, but it was a fun exercise to see if a key-value container type that might compete with `Hash(K,V)`'s performance could be built easily.

## Installation

1. Add the dependency to your `shard.yml`:

   ```yaml
   dependencies:
     dict.cr:
       github: galvertez/dict.cr
   ```

2. Run `shards install`

## Usage

```crystal
require "dict.cr"
```

`Dict(W,D)` is meant to be used more or less like `Hash(K,V)`.

```crystal
dict = Dict{
  "something" => "nothing",
  "alpha" => "beta",
  "eleven" => 11,
  "seven thousand" => 7000
}

alpha = dict["alpha"] # => "beta"
```

For example, a script like

```crystal
dict.each do |word, definition|
  printf "#{word} = #{definition}\n"
end
```

will print

```text
alpha = beta
eleven = 11
seven thousand = 7000
something = nothing
```

If you like, you can use the english syntax, rather than `[]` and `[]=`

```crystal
dict.define "alpha", "beta"
dict.lookup "alpha" # => "beta"
```

As it currently stands, `Dict(W,D)` will likely not work properly with union types as the word (`W`), but should work just fine with union type definitions (`D`), because of how heavily it relies on `Comparable(T)`

## Contributing

1. Fork it (<https://github.com/galvertez/dict.cr/fork>)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Contributors

- [galvertez](https://github.com/your-github-user) - creator and maintainer
