require "spec_helper"

require "faith_and_farming/page"

describe FaithAndFarming::Page do

  let(:page) { described_class.load(page_no) }

  context "on a random page" do

    let(:page_no) { 400 }

    describe "first paragraph" do

      it "loads correctly" do
        expect(page.blocks[0].paragraphs[0].text).to eq("The Descendants of Caroline Elizabeth and Samuel Blomfield Ludbrook\n")
      end

    end

  end

  context "on a family-tree page" do

    let(:page_no) { 220 }

    describe "#descendants_of" do

      it "summarises the 'Descendants of ...' block" do
        expect(page.descendants_of).to eq ([
          "WILLIAMS, Henry and COLDHAM, Marianne",
          "WILLIAMS, Marianne and DAVIES, Christopher Pearson",
          "DAVIES, Christopher Pearson and WILLIAMS, Mary Anne",
          "DAVIES, Freda Lilian and DODGSHUN, Gordon Mawley",
          "DODGSHUN, Sydney Yorke and WOODWARD, Dorothy Virginia",
          "DODGSHUN, Philippa Robyn and JACKMAN, Peter Heathcote"
        ])
      end

    end

    describe "#tree_entries" do

      it "represent each tree entry" do
        expect(page.tree_entries[0].subject.name).to eql("JACKMAN, Nicola Jane Heathcote")
        expect(page.tree_entries[1].subject.name).to eql("JACKMAN, Rachael Anne Heathcote")
      end

    end

  end

end
