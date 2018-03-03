require "spec_helper"

require "faith_and_farming/page"

describe FaithAndFarming::Page do

  describe "p400" do

    let(:page_no) { 400 }
    let(:page) { described_class.load(page_no) }

    describe "first paragraph" do

      it "loads correctly" do
        expect(page.blocks[0].paragraphs[0].text).to eq("The Descendants of Caroline Elizabeth and Samuel Blomfield Ludbrook")
      end

    end
    
  end

end
