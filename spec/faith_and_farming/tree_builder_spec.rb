require "spec_helper"

require "faith_and_farming/book/elements/entry"
require "faith_and_farming/tree_builder"

describe FaithAndFarming::TreeBuilder do

  subject(:builder) { described_class.new }

  def entry(attributes)
    FaithAndFarming::Book::Elements::Entry.from_data(attributes)
  end

  def individual_entry(level: 1, **rest)
    entry(level: level, people: [rest])
  end

  let(:db) do
    builder.process(elements).db
  end

  context "with an individual entry" do

    let(:joe_entry) { individual_entry(name: "BLOGGS, Joe") }
    let(:elements) { [joe_entry] }

    it "creates an Individual" do
      expect(db.individuals.size).to eq(1)
    end

    it "sets name" do
      expect(db.individuals.first.name).to eq("Joe BLOGGS")
    end

    context "with birth/death dates" do

      let(:joe_entry) do
        individual_entry(name: "BLOGGS, Joe", date_of_birth: "12.05.1954", date_of_death: "15.11.1996")
      end

      it "records dates of birth and death" do
        expect(db.individuals.first.date_of_birth).to eq(Familial::Date.new(1954, 5, 12))
        expect(db.individuals.first.date_of_death).to eq(Familial::Date.new(1996, 11, 15))
      end

    end

  end

  context "with a couple entry" do

    let(:elements) do
      [
        entry(
          level: 1,
          date_married: "**.03.1966",
          people: [
            { name: "MCTAVISH, Bob" },
            { name: "FIFINGER, Audrey" }
          ]
        )
      ]
    end

    it "creates two Individuals" do
      expect(db.individuals.size).to eq(2)
      expect(db.individuals.map(&:name)).to include("Bob MCTAVISH", "Audrey FIFINGER")
    end

  end

end
