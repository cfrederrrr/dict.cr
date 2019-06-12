require "./spec_helper"

describe Dict do
  it "has a hashlike initializer" do
    dict = Dict{"something"=>"something else", "nothing"=>"nothing else"}
    dict["something"].should eq("something else")
    dict["nothing"].should eq("nothing else")
  end

  it "is always sorted" do
    Dict::SPEC_INSTANCE.words.should eq(Dict::ENGLISH_WORDS.sort)
  end

  describe "#[]" do
    it "returns the associated value" do
      Dict::SPEC_INSTANCE["health"].should eq(Digest::SHA1.hexdigest("health"))
    end
  end

  describe "#lookup" do
    it "returns the associated value" do
      Dict::SPEC_INSTANCE["health"].should eq(Digest::SHA1.hexdigest("health"))
    end
  end

  describe "#[]=" do
    dict = Dict(String, String).new

    it "accepts words and definitions" do
      dict["something"] = "something else"
      dict["nothing"] = "nothing else"

      dict["something"].should eq("something else")
      dict["nothing"].should eq("nothing else")
    end

    it "overwrites existing values" do
      dict["something"] = "abcdefghijklmnopqrstuvwxyz"
      dict["something"].should eq("abcdefghijklmnopqrstuvwxyz")
    end
  end

  describe "#define" do
    dict = Dict(String, String).new

    it "accepts words and definitions" do
      dict["something"] = "something else"
      dict["nothing"] = "nothing else"

      dict["something"].should eq("something else")
      dict["nothing"].should eq("nothing else")
    end

    if "overwrites existing values" do
      dict["something"] = "abcdefghijklmnopqrstuvwxyz"
      dict["something"].should eq("abcdefghijklmnopqrstuvwxyz")
    end
  end
end
