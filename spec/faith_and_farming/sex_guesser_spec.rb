require "spec_helper"

require "faith_and_farming/sex_guesser"

describe FaithAndFarming::SexGuesser do

  describe ".uk" do

    let(:guesser) { described_class.uk }

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

  context "with test names" do

    let(:guesser) { described_class.new }

    before do
      guesser.add_name("Abraham", 1)
      guesser.add_name("Robin", 0.8)
      guesser.add_name("Adeen", 0.5)
      guesser.add_name("Leone", 0.4)
      guesser.add_name("Marie", 0.0)
    end

    describe "#maleness" do

      context "with a single name" do
        it "returns the configured value" do
          expect(guesser.maleness("Robin")).to eq(0.8)
        end
      end

      context "with an unknown name" do
        it "returns 0.5" do
          expect(guesser.maleness("Bartleby")).to eq(0.5)
        end
      end

      context "with multiple names" do
        it "returns an average" do
          expect(guesser.maleness("Abraham Robin")).to eq(0.9)
        end
      end

    end

  end

end
