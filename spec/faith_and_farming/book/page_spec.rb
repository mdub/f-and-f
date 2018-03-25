require "spec_helper"

require "faith_and_farming/book/page"

describe FaithAndFarming::Book::Page do

  def load(page_no)
    described_class.load(page_no)
  end

  let(:page) { load(page_no) }

  context "on a random page" do

    let(:page_no) { 400 }

    describe "first paragraph" do

      it "loads correctly" do
        expect(page.blocks[0].paragraphs[0].text).to eq("The Descendants of Caroline Elizabeth and Samuel Blomfield Ludbrook\n")
      end

      it "has correct bounds" do
        bounds = page.blocks[0].paragraphs[0].bounds
        expect(bounds.left).to eql(359)
        expect(bounds.right).to eql(2033)
        expect(bounds.top).to eql(229)
        expect(bounds.bottom).to eql(277)
      end

    end

  end

  context "on a non-tree page" do

    let(:page_no) { 400 }

    describe "#descendants_of" do
      it "is nil" do
        expect(page.descendants_of).to eql(nil)
      end
    end

    describe "#entry_offset" do
      it "is nil" do
        expect(page.entry_offset).to eql(nil)
      end
    end

  end

  context "on a family-tree page" do

    let(:page_no) { 220 }

    describe "#descendants_of" do

      it "summarises the 'Descendants of ...' block" do
        expect(page.descendants_of).to eql([
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

      describe "element" do

        describe "#level" do

          it "returns the tree level" do
            expect(page.tree_entries[0].level).to eql(6)
            expect(page.tree_entries[2].level).to eql(5)
            expect(page.tree_entries.last.level).to eql(4)
          end

        end

      end

    end

    describe "#entry_offset" do

      it %{returns the indent of "1 2 3 4 5 6 7 8 9"} do
        expect(page.entry_offset).to eql(212)
      end

    end

  end

end
