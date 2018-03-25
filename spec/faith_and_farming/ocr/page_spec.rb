require "spec_helper"

require "faith_and_farming/ocr/page"

describe FaithAndFarming::OCR::Page do

  def load(page_no)
    $cache ||= {}
    $cache[page_no] ||= described_class.load(page_no)
  end

  let(:page) { load(page_no) }

  context "on a random page" do

    let(:page_no) { 400 }

    describe "first paragraph" do

      it "loads correctly" do
        expect(page.blocks[0].paragraphs[0].text).to eq("The Descendants of Caroline Elizabeth and Samuel Blomfield Ludbrook\n")
      end

    end

  end

end
