require "spec_helper"

require "faith_and_farming/book/elements/entry"
require "faith_and_farming/tree_builder"

describe FaithAndFarming::TreeBuilder do

  subject(:builder) { described_class.new }

  def start_of_page(n)
    FaithAndFarming::Book::Elements::StartOfPage.new(n)
  end

  def make_entry(attributes)
    FaithAndFarming::Book::Elements::Entry.from_data(attributes)
  end

  def individual_entry(level: 1, note: nil, **rest)
    make_entry(level: level, note: note, people: [rest])
  end

  let(:elements) do
    [
      start_of_page(123)
    ]
  end

  let(:db) do
    builder.process(elements).db
  end

  context "with an individual entry" do

    let(:entry) { individual_entry(name: "BLOGGS, Joe") }

    before do
      elements << entry
    end

    it "creates an Individual" do
      expect(db.individuals.size).to eq(1)
    end

    it "sets name" do
      expect(db.individuals.first.name).to eq("Joe /BLOGGS/")
    end

    it "guesses sex" do
      expect(db.individuals.first.sex).to eq(Familial::Sex.male)
    end

    it "does not create a Family" do
      expect(db.families).to be_empty
    end

    context "with birth/death dates" do

      let(:entry) do
        individual_entry(name: "BLOGGS, Joe", date_of_birth: "12.05.1954", date_of_death: "15.11.1996")
      end

      it "records dates of birth and death" do
        expect(db.individuals.first.date_of_birth).to eq(Familial::Date.new(1954, 5, 12))
        expect(db.individuals.first.date_of_death).to eq(Familial::Date.new(1996, 11, 15))
      end

    end

    context "with nickname" do

      let(:entry) do
        individual_entry(name: "BLOGGS, Joseph (Joe)")
      end

      let(:joe) { db.individuals.first }

      it "sets name" do
        expect(joe.name).to eq("Joseph /BLOGGS/")
      end

      it "sets nickname" do
        expect(joe.nickname).to eq("Joe")
      end

    end

    context "with a note" do

      let(:text) { "Sally so fine\n" }

      let(:entry) do
        individual_entry(name: "SMITH, Sally", note: text)
      end

      it "creates a Note" do
        expect(db.notes.size).to eq(1)
        expect(db.notes.first.content).to eq(text)
      end

      it "links the Note" do
        expect(db.individuals.first.note).to be(db.notes.first)
      end

    end

  end

  context "with a couple entry" do

    before do
      elements << make_entry(
        level: 1,
        date_married: "**.03.1966",
        people: [
          { name: "MCTAVISH, Bob" },
          { name: "FIFINGER, Audrey" }
        ]
      )
    end

    it "creates two Individuals" do
      expect(db.individuals.size).to eq(2)
      expect(db.individuals.map(&:name)).to include("Bob /MCTAVISH/", "Audrey /FIFINGER/")
    end

    it "creates a Family" do
      expect(db.families.size).to eq(1)
    end

    let(:family) { db.families.first }

    it "records date of marriage" do
      expect(family.date_married).to eq(Familial::Date.new(1966, 3))
    end

    it "associates husband and wife" do
      expect(family.husband).to eq(db.find("Bob /MCTAVISH/"))
      expect(family.wife).to eq(db.find("Audrey /FIFINGER/"))
    end

  end

  context "with a couple followed by children" do

    before do
      elements << make_entry(
        level: 1,
        date_married: "**.03.1966",
        people: [
          { name: "MCTAVISH, Bob" },
          { name: "FIFINGER, Audrey" }
        ]
      )
      elements << make_entry(
        level: 2,
        people: [
          { name: "MCTAVISH, Roger" }
        ]
      )
      elements << make_entry(
        level: 2,
        people: [
          { name: "MCTAVISH, Cindy" }
        ]
      )
    end

    it "creates all Individuals" do
      expect(db.individuals.size).to eq(4)
    end

    it "creates a Family" do
      expect(db.families.size).to eq(1)
    end

    let(:family) { db.families.first }

    it "associates children" do
      expect(family.children.map(&:name)).to include(
        "Roger /MCTAVISH/",
        "Cindy /MCTAVISH/"
      )
    end

  end

  context "with two generations" do

    before do
      elements << make_entry(
        level: 1,
        people: [
          { name: "MCTAVISH, Bob" },
          { name: "FIFINGER, Audrey" }
        ]
      )
      elements << make_entry(
        level: 2,
        people: [
          { name: "MCTAVISH, Molly" },
          { name: "WANDSWORTH, Willy" }
        ]
      )
      elements << make_entry(
        level: 3,
        people: [
          { name: "WANDSWORTH, Jock" }
        ]
      )
      elements << make_entry(
        level: 2,
        people: [
          { name: "MCTAVISH, George" }
        ]
      )
    end

    it "creates all Individuals" do
      expect(db.individuals.size).to eq(6)
    end

    it "creates both Families" do
      expect(db.families.size).to eq(2)
    end

    it "associates children correctly" do
      expect(db.families.to_a[0].children.map(&:name)).to eq(["Molly /MCTAVISH/", "George /MCTAVISH/"])
      expect(db.families.to_a[1].children.map(&:name)).to eq(["Jock /WANDSWORTH/"])
    end

  end

end
