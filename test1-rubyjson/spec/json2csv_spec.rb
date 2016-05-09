require 'spec_helper'

describe 'Helper methods' do
  let(:hash) { {a: {b: [:c, :d], e: :f}, g: {h: {i: {j: :k}}}} }
  describe '#prefix' do
    it "should apply a prefix to an array and its sub-elements" do
      expect(prefix("hello ", ["my honey", ["my darling", ["my ragtime gal !"]]]))
        .to match_array ["hello my honey", ["hello my darling", ["hello my ragtime gal !"]]]
    end
  end

  describe '#labels' do
    it "should return an array of the stringified keys of a nested hash" do
      expect(labels(hash, separator: '-'))
        .to match_array ["a-b", "a-e", "g-h-i-j"]
      expect(labels(hash, separator: ''))
        .to match_array ["ab", "ae", "ghij"]
    end
  end

  describe '#get_value' do
    it 'should return the value at the path given in parameter' do
      expect(get_value(hash, [:a, :b])).to match_array [:c, :d]
      expect(get_value(hash, [:g, :h, :i])).to eq({ j: :k })
      expect(get_value(hash, [:a, :e])).to eq :f
    end
  end

  describe '#csvize' do
    it 'should format arrays to strings ready to be written' do
      expect(csvize(["hello", "helloooo", "helloooooo", "hello", "oh noooo", "boom"]))
        .to eq "hello,helloooo,helloooooo,hello,oh noooo,boom"
    end
    it "shouldn't denaturate strings" do
      expect(csvize("hello mine turtle !")).to eq "hello mine turtle !"
    end
  end
end

describe 'Converter' do
  it 'should convert a JSON file to the expected CSV format' do
    url = "https://gist.githubusercontent.com/gregclermont/ca9e8abdff5dee9ba9db/raw/7b2318efcf8a7048f720bcaff2031d5467a4a2c8/users.json"
    output = "livementest.csv"

    # Example file converted by hand
    #   (, -> ; / "..." -> .,.,.)
    # from source Gist.
    example = "example_output.csv"

    json2csv(url, output)
    expect(open(output).read()).to eq open(example).read()
  end
end
