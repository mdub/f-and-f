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
        it "returns nil" do
          expect(guesser.maleness("Bartleby")).to eq(nil)
        end
      end

      context "with multiple names" do

        def average(*values)
          values.map(&:to_f).inject(:+) / values.size.to_f
        end

        it "returns a weighted average" do
          expect(guesser.maleness("Abraham Adeen")).to eq(average(1, 1, 0.5))
        end

        it "ignores unknown names" do
          expect(guesser.maleness("Abraham Fnord")).to eq(1)
        end

        it "handles totally unknown names" do
          expect(guesser.maleness("Foo Bar")).to eq(nil)
        end

      end

    end

    describe "#guess_sex" do

      context "with a male name" do
        it "returns :male" do
          expect(guesser.guess_sex("Abraham")).to eq(:male)
        end
      end

      context "with a female name" do
        it "returns :female" do
          expect(guesser.guess_sex("Marie")).to eq(:female)
        end
      end

      context "with an unpredictable name" do
        it "returns nil" do
          expect(guesser.guess_sex("Adeen")).to eq(nil)
        end
      end

      context "with an unknown name" do
        it "returns nil" do
          expect(guesser.guess_sex("Fnord")).to eq(nil)
        end
      end

    end

  end

end
