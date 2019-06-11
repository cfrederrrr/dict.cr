require "spec"
require "../src/dict.cr"
require "digest"

Dict::ENGLISH_WORDS = File.read_lines(
                      File.join(
                      File.dirname(
                      File.expand_path(__FILE__)), "english-words.txt"))

Dict::SPEC_INSTANCE = Dict(String,String).new

Dict::ENGLISH_WORDS.shuffle.each do |word|
  Dict::SPEC_INSTANCE[word] = Digest::SHA1.hexdigest(word)
end
