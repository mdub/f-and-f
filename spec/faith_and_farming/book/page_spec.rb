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

end
