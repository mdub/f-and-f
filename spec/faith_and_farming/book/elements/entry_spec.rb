require "spec_helper"

require "faith_and_farming/book/elements/entry"

describe FaithAndFarming::Book::Elements::Entry do

  describe ".from" do

    let(:entry) { described_class.from(text) }

    context "random text" do

      let(:text) { "hello" }

      it "returns nil" do
        expect(entry).to eq(nil)
      end

    end

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
        expect(entry).to be_kind_of(FaithAndFarming::Book::Elements::Entry)
      end

      it "extracts one individual" do
        expect(entry.people.size).to eq(1)
      end

      let(:person) { entry.people.first }

      it "extracts name" do
        expect(person.name).to eq("WILLIAMS, Anna Lydia")
      end

      it "extracts date of birth" do
        expect(person.date_of_birth).to eq("06.07.1854")
      end

      it "extracts date of death" do
        expect(person.date_of_death).to eq("20.06.1938")
      end

      it "extracts notes" do
        expect(entry.note).to eq <<~TEXT
          Lydia b. at Otaki and d. at Napier. She began to lose her sight at the age of 18 and was completely blind by
          the time she was 22. She had a keen mind and retained a lively interest in local and world events, and in the
          progress of the Church's mission, throughout her life.
        TEXT
      end

    end

    context "with no notes" do

      let(:text) do
        <<~TEXT
          02> WILLIAMS, Anna Lydia
          b 06.07.1854 d 20.06.1938
        TEXT
      end

      it "leaves notes nil" do
        expect(entry.note).to eq(nil)
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
        expect(entry.people.map(&:name)).to eq [
          "WILLIAMS, William Temple",
          "PUCKEY, Annie Matilda Sophia Marilla"
        ]
      end

      it "extracts dates of birth and death" do
        expect(entry.people).to include(
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
        expect(entry.date_married).to eq("31.03.1891")
      end

      context "with missing space" do

        let(:text) do
          <<~TEXT
            01> FRASER, Carolm on 09.04.1974 to NELSON, Paul Sunderland
            b 18.07.1950
            b 02.12.1947
          TEXT
        end

        it "extracts both people" do
          expect(entry.people.map(&:name)).to eq [
            "FRASER, Carol",
            "NELSON, Paul Sunderland"
          ]
        end

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
        expect(entry.people.map(&:name)).to eq [
          "DODGSHUN, Paul Sydney",
          "HUNT, Bronwyn Margaret"
        ]
      end

      it "extracts date of marriage" do
        expect(entry.date_married).to eq("02.03.1996")
      end

      context "with extra spaces" do

        let(:text) do
          <<~TEXT
            03> DODGSHUN, Paul Sydney m on 02.03.1996 to (2) HUNT, Bronwyn Margaret
            b 04.06.1953
            b 02.08.1955
          TEXT
        end

        it "extracts both names" do
          expect(entry.people.map(&:name)).to eq [
            "DODGSHUN, Paul Sydney",
            "HUNT, Bronwyn Margaret"
          ]
        end

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
        expect(entry.people.map(&:name)).to eq [
          "REED, Celia Elizabeth",
          "PAXMAN, Arthur Keith"
        ]
      end

    end

    context "with date placeholders" do

      let(:text) do
        <<~TEXT
          03> DAVIES, Nina Pearson m on ** ** **** to PEDERSON, Peder
          b 13.02.1888. d 23.10.1952
          b ** ** **** d ** ** ****
          Nina b. at Gisborne. No children.
        TEXT
      end

      it "extracts wildcard marriage date" do
        expect(entry.date_married).to eq("**.**.****")
      end

      it "extracts wildcard dates of birth and death" do
        peder = entry.people[1]
        expect(peder.date_of_birth).to eq("**.**.****")
        expect(peder.date_of_death).to eq("**.**.****")
      end

    end

    context "with badly scanned marriage date" do

      let(:text) do
        <<~TEXT
          01> TRIPE, Susan Elizabeth m on ** **, 1951 to (1) SALMOND, Graham Wilson
          b 06.07.1932
          b 12.03.1922
        TEXT
      end

      it "extracts wildcard marriage date" do
        expect(entry.date_married).to eq("**.**.1951")
      end

    end

    context "with '0' mis-parsed as '6'" do

      let(:text) do
        <<~TEXT
          64> GRAY, Anthony Charles m on 29.09.1989 to (2) MABEY, Gail Ann McLaren
          b 23.07.1948
          b 10.04.1955
        TEXT
      end

      it "is still recognised" do
        expect(entry).to be_kind_of(FaithAndFarming::Book::Elements::Entry)
        expect(entry.people.first.name).to eq("GRAY, Anthony Charles")
      end

    end

    context "with a stray apostrophe before the space" do

      let(:text) do
        <<~TEXT
          02>' WATSON, Edith Ruth m on 19.11.1982 to (2)CARTER, Dudley Robert (Nick)
          b 06.07.1933
          b 13.04.1931
        TEXT
      end

      it "is still recognised" do
        expect(entry).to be_kind_of(FaithAndFarming::Book::Elements::Entry)
        expect(entry.people.first.name).to eq("WATSON, Edith Ruth")
      end

    end

    context "with a stray apostrophe after the space" do

      let(:text) do
        <<~TEXT
          01> 'NEWTON, Thomas Alexander
          b 20.12.1980
          Thomas b. at Takaka.
        TEXT
      end

      it "is still recognised" do
        expect(entry).to be_kind_of(FaithAndFarming::Book::Elements::Entry)
        expect(entry.people.first.name).to eq("NEWTON, Thomas Alexander")
      end

    end

    context "with ten or more kids" do

      let(:text) do
        <<~TEXT
          10> GRAY, Olive Sheila m on 08.06.1946 to (1) TOMBLESON, Michael John
          b 23.07.1923
          b 25.08.1921 d 22.08.1971
          Sheila b. at Eketahuna and m, at Gisborne. Michael, s/o Percy Douglas Tombleson and Mary Dods, killed
          in a car accident and bd. at Morrinsville.
        TEXT
      end

      it "is still recognised" do
        expect(entry).to be_kind_of(FaithAndFarming::Book::Elements::Entry)
        expect(entry.people.first.name).to eq("GRAY, Olive Sheila")
      end

    end

  end

end
