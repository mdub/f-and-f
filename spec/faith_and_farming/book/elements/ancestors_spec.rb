require "spec_helper"

require "faith_and_farming/book/elements/ancestors"

describe FaithAndFarming::Book::Elements::Ancestors do

  describe ".from" do

    let(:result) { described_class.from(text) }

    context "random text" do

      let(:text) { "hello" }

      it "returns nil" do
        expect(result).to eq(nil)
      end

    end

    context "an ancestry block" do

      let(:text) do
        <<~TEXT
          Descendants of WILLIAMS, Henry and COLDHAM, Marianne
          JWILLIAMS, Marianne and DAVIES, Christopher Pearson
          IDAVIES, Christopher Pearson and WILLIAMS, Mary Anne
          JDAVIES, Freda Lilian and DODGSHUN, Gordon Mawley
          JDODGSHUN, Sydney Yorke and WOODWARD, Dorothy Virginia
          JDODGSHUN, Philippa Robyn and JACKMAN, Peter Heathcote
        TEXT
      end

      it "returns an Ancestors element" do
        expect(result).to be_kind_of(described_class)
      end

      it "includes ancestor lists" do
        expect(result.lines).to eq [
          "WILLIAMS, Henry and COLDHAM, Marianne",
          "WILLIAMS, Marianne and DAVIES, Christopher Pearson",
          "DAVIES, Christopher Pearson and WILLIAMS, Mary Anne",
          "DAVIES, Freda Lilian and DODGSHUN, Gordon Mawley",
          "DODGSHUN, Sydney Yorke and WOODWARD, Dorothy Virginia",
          "DODGSHUN, Philippa Robyn and JACKMAN, Peter Heathcote"
        ]
      end

    end

  end
end
