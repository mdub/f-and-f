require "spec_helper"

require "faith_and_farming/book/utils"

describe FaithAndFarming::Book::Utils do

  describe "#normalise_date" do

    def expect_normalise_date(input, expected_output)
      output = described_class.normalise_date(input)
      expect(output).to eq(expected_output)
    end

    it "is a no-op for normal dates" do
      expect_normalise_date("11.09.1856", "11.09.1856")
      expect_normalise_date("**.**.****", "**.**.****")
    end

    it "is a no-op for nil" do
      expect_normalise_date(nil, nil)
    end

    it "cleans up dodgy wildcard dates" do
      expect_normalise_date("** ** ****", "**.**.****")
      expect_normalise_date("********", "**.**.****")
    end

    it "strips trailing periods" do
      expect_normalise_date("29.07.1982.", "29.07.1982")
    end

  end

end
