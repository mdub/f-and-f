require "spec_helper"

require "faith_and_farming/sex_guesser"

describe FaithAndFarming::SexGuesser do

  subject(:guesser) { described_class.new }

  describe "#guess_sex" do

    def self.guesses(name, expected_result)
      it "says #{name} is #{expected_result}" do
        expect(guesser.guess_sex(name)).to eq(expected_result)
      end
    end

    guesses "Bruce", :male
    guesses "Sally", :female

    guesses "Robin", :male
    guesses "Mary", :female

  end

end
