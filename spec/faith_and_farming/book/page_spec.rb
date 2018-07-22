require "spec_helper"

require "faith_and_farming/book/page"
require "faith_and_farming/book/elements/ancestors"

describe FaithAndFarming::Book::Page do

  def load(page_index)
    described_class.load(page_index)
  end

  let(:page) { load(page_index) }

  context "on a random page" do

    let(:page_index) { 400 }

    it "has a page_index" do
      expect(page.page_index).to eq(400)
    end

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

    let(:page_index) { 400 }

    describe "#entry_offset" do
      it "is nil" do
        expect(page.entry_offset).to eql(nil)
      end
    end

  end

  context "on a family-tree page" do

    let(:page_index) { 220 }

    describe "#entry_offset" do

      it %{returns the indent of "1 2 3 4 5 6 7 8 9"} do
        expect(page.entry_offset).to eql(212)
      end

    end

    describe "#elements" do

      it "includes ancestors" do
        expect(page.elements).to include(
          an_instance_of(FaithAndFarming::Book::Elements::Ancestors) & having_attributes(
            lines:  [
              "WILLIAMS, Henry and COLDHAM, Marianne",
              "WILLIAMS, Marianne and DAVIES, Christopher Pearson",
              "DAVIES, Christopher Pearson and WILLIAMS, Mary Anne",
              "DAVIES, Freda Lilian and DODGSHUN, Gordon Mawley",
              "DODGSHUN, Sydney Yorke and WOODWARD, Dorothy Virginia",
              "DODGSHUN, Philippa Robyn and JACKMAN, Peter Heathcote"
            ]
          )
        )
      end

      it "includes entries" do
        expect(page.elements).to include(
          an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
            level: 6,
            people: a_collection_including(
              having_attributes(
                name: "JACKMAN, Nicola Jane Heathcote"
              )
            )
          ),
          an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
            level: 6,
            people: a_collection_including(
              having_attributes(
                name: "JACKMAN, Rachael Anne Heathcote"
              )
            )
          ),
          an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
            level: 5,
            people: a_collection_including(
              having_attributes(
                name: "DODGSHUN, Paul Sydney"
              )
            )
          ),
          an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
            level: 4,
            people: a_collection_including(
              having_attributes(
                name: "DODGSHUN, Truby Edward"
              )
            )
          ),
          an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
            level: 4,
            people: a_collection_including(
              having_attributes(
                name: "DODGSHUN, Kenneth Christopher"
              )
            )
          )
        )
      end

      it "extracts birth and death dates" do
        expect(page.elements).to include(
          an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
            people: a_collection_including(
              having_attributes(
                name: "DODGSHUN, Truby Edward",
                birth_date: "26.02.1922",
                death_date: "12.09.1944"
              )
            )
          )
        )
      end

      context "with a marriage" do

        let(:page_index) { 227 }

        it "extracts both parties" do
          expect(page.elements).to include(
            an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
              level: 2,
              people: a_collection_including(
                having_attributes(
                  name: "WILLIAMS, William Temple"
                ),
                having_attributes(
                  name: "PUCKEY, Annie Matilda Sophia Marilla"
                )
              )
            )
          )
        end

        it "extracts marriage date" do
          expect(page.elements).to include(
            an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
              level: 2,
              marriage_date: "31.03.1891",
              people: a_collection_including(
                having_attributes(
                  name: "WILLIAMS, William Temple"
                ),
                having_attributes(
                  name: "PUCKEY, Annie Matilda Sophia Marilla"
                )
              )
            )
          )
        end

        it "extracts birth and death dates for both parties" do
          expect(page.elements).to include(
            an_instance_of(FaithAndFarming::Book::Elements::Entry) & having_attributes(
              level: 2,
              people: a_collection_including(
                having_attributes(
                  name: "WILLIAMS, William Temple",
                  birth_date: "16.03.1856",
                  death_date: "01.04.1928"
                ),
                having_attributes(
                  name: "PUCKEY, Annie Matilda Sophia Marilla",
                  birth_date: "26.06.1858",
                  death_date: "22.08.1938"
                )
              )
            )
          )
        end

      end

    end

  end

end
