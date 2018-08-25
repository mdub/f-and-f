require "spec_helper"

require "faith_and_farming/book"

describe FaithAndFarming::Book, "family tree" do

  before(:all) do
    @tree = FaithAndFarming::Book.family_tree(last_page: 199)
  end

  attr_reader :tree

  class << self

    def born(expected_date)
      it "was born on #{expected_date}" do
        expect(subject.date_of_birth.to_date).to eq(Date.parse(expected_date))
      end
    end

    def died(expected_date)
      it "and died on #{expected_date}" do
        expect(subject.date_of_death.to_date).to eq(Date.parse(expected_date))
      end
    end

  end

  describe "Henry Williams" do

    subject(:henry) { tree.individuals.get(name: "Henry /Williams/") }

    born "11.2.1792"
    died "16.7.1867"

    it "had 11 children" do
      kids_names = henry.families.first.children.map { |i| i.name.split(" ").first }
      expect(kids_names).to eq %w[
        Edward
        Marianne
        Samuel
        Henry
        Thomas
        John
        Sarah
        Catherine
        Caroline
        Lydia
        Joseph
      ]
    end

  end

  describe "Marianne Coldham" do

    subject(:marianne) { tree.individuals.get(name: "Marianne /Coldham/") }

    born "12.12.1793"
    died "16.12.1879"

    it "was married to Henry" do
      husband = marianne.families.first.husband
      expect(husband.name).to eq("Henry /Williams/")
    end

  end

  describe "Edward Marsh Williams" do

    subject(:edward) { tree.individuals.get(name: "Edward Marsh /Williams/") }

    born "02.11.1818"
    died "11.10.1909"

    it "appears once" do
      matches = tree.individuals.with(name: edward.name, date_of_birth: edward.date_of_birth)
      expect(matches.size).to eq(1)
    end

    it "was married once" do
      expect(edward.families.size).to eq(1)
    end

    it "was married to Jane Davis" do
      expect(edward.families.first.wife.name).to eq("Jane /Davis/")
    end

    it "had 14 children" do
      kids_names = edward.families.first.children.map { |i| i.name.split(" ").first }
      expect(kids_names).to eq %w[
        Henry
        Samuel
        Thomas
        Mary
        Allen
        Joseph
        Alfred
        George
        Arthur
        Ellen
        Norman
        Emma
        Ada
      ]
    end

  end

  describe "Ralph Overbye" do

    subject(:ralph) { tree.individuals.get(name: "Ralph Douglas /Overbye/") }

    born "28.07.1969"

    it "was educated in Gisborne Mataurangi" do
      expect(ralph.note.content).to include(
        "educated at Makauri School, Gisborne"
      )
    end

    it "is a church elder" do
      expect(ralph.note.content).to include(
        "elders at Son City Apostolic Church in Gisborne"
      )
    end

  end

end
