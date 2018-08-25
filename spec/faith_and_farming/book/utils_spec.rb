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
      expect_normalise_date("****.1972", "**.**.1972")
    end

    it "cleans up spacing" do
      expect_normalise_date("**.**. 1997", "**.**.1997")
      expect_normalise_date("11.03. ****", "11.03.****")
      expect_normalise_date("** **, 1945", "**.**.1945")
      expect_normalise_date("** ** , 1945", "**.**.1945")
    end

    it "strips trailing periods" do
      expect_normalise_date("29.07.1982.", "29.07.1982")
    end

  end

  describe "#normalise_name" do

    def expect_normalise_name(input, expected_output)
      output = described_class.normalise_name(input)
      expect(output).to eq(expected_output)
    end

    it "capitalizes surnames" do
      expect_normalise_name("AVERILL, Sarah Lucy", "Averill, Sarah Lucy")
    end

    it "handles complex surnames" do
      expect_normalise_name("FULSOME-JONES, Sarah Marie", "Fulsome-Jones, Sarah Marie")
      expect_normalise_name("VAN DER ZIJPP, Jacob", "van der Zijpp, Jacob")
      expect_normalise_name("MCKENNA, Jeanne", "McKenna, Jeanne")
      expect_normalise_name("O'CONNOR, Elizabeth Jane", "O'Connor, Elizabeth Jane")
      expect_normalise_name("HARRÉ, Urma Ra Awatea", "Harré, Urma Ra Awatea")
    end

    it "cleans up stray whitespace" do
      expect_normalise_name("WYNNE - LEWIS, Peter Thomas", "Wynne-Lewis, Peter Thomas")
      expect_normalise_name("PAGE , Matthew Edward", "Page, Matthew Edward")

    end

  end

end
