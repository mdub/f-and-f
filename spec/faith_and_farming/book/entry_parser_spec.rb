require "spec_helper"

require "faith_and_farming/book/entry_parser"

describe FaithAndFarming::Book::EntryParser do

  describe "#parse" do

    let(:result) { described_class.parse(text) }

    context "an individual entry" do

      let(:text) do
        <<~TEXT
          02> WILLIAMS, Anna Lydia
          b 06.07.1854 d 20.06.1938
          Lydia b. at Otaki and d. at Napier. She began to lose her sight at the age of 18 and was completely blind by
          the time she was 22. She had a keen mind and retained a lively interest in local and world events, and in the
          progress of the Church's mission, throughout her life.
        TEXT
      end

      it "returns an Entry" do
        expect(result).to be_kind_of(FaithAndFarming::Book::Elements::Entry)
      end

      it "extracts one individual" do
        expect(result.people.size).to eq(1)
      end

      let(:person) { result.people.first }

      it "extracts name" do
        expect(person.name).to eq("WILLIAMS, Anna Lydia")
      end

      it "extracts date of birth" do
        expect(person.date_of_birth).to eq("06.07.1854")
      end

      it "extracts date of death" do
        expect(person.date_of_death).to eq("20.06.1938")
      end

    end

    context "a couple entry" do

      let(:text) do
        <<~TEXT
          03> WILLIAMS, William Temple m on 31.03.1891 to PUCKEY, Annie Matilda Sophia Marilla
          b 16.03.1856 d 01.04.1928
          b 26.06.1858 d 22.08.1938
          William b. at Te Aute, m. at St Barnabas Church, Mount Ede, Auckland and d. at Te
          Aute. William and Annie both bd, at Pukehou Cemetery.
          William suffered poor health as a child and in 1886 his parents sent him to England
          for treatment. He spent several years in spas and sanatoria in England and Switzerland
          and returned much improved. He helped with the running of "Te Aute" station and
          supervised the work on the farm after his father's death.
        TEXT
      end

      it "extracts both people" do
        expect(result.people.map(&:name)).to eq [
          "WILLIAMS, William Temple",
          "PUCKEY, Annie Matilda Sophia Marilla"
        ]
      end

      it "extracts dates of birth and death" do
        expect(result.people).to include(
          an_object_having_attributes(
            name: "WILLIAMS, William Temple",
            date_of_birth: "16.03.1856",
            date_of_death: "01.04.1928"
          ),
          an_object_having_attributes(
            name: "PUCKEY, Annie Matilda Sophia Marilla",
            date_of_birth: "26.06.1858",
            date_of_death: "22.08.1938"
          )
        )
      end

      it "extracts date of marriage" do
        expect(result.marriage_date).to eq("31.03.1891")
      end

    end

    context "a second or third marriage" do

      let(:text) do
        <<~TEXT
          03> DODGSHUN, Paul Sydney m on 02.03.1996 to (2)HUNT, Bronwyn Margaret
          b 04.06.1953
          b 02.08.1955
        TEXT
      end

      it "extracts both people" do
        expect(result.people.map(&:name)).to eq [
          "DODGSHUN, Paul Sydney",
          "HUNT, Bronwyn Margaret"
        ]
      end

      it "extracts date of marriage" do
        expect(result.marriage_date).to eq("02.03.1996")
      end

    end

    context "a de facto couple" do

      let(:text) do
        <<~TEXT
          02> REED, Celia Elizabeth de facto PAXMAN, Arthur Keith
          b 14.11.1941
          b 12.05.1922
        TEXT
      end

      it "extracts both people" do
        expect(result.people.map(&:name)).to eq [
          "REED, Celia Elizabeth",
          "PAXMAN, Arthur Keith"
        ]
      end

    end

  end

end
