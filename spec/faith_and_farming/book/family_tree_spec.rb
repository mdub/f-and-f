require "spec_helper"

require "faith_and_farming/book"

describe FaithAndFarming::Book, "family tree" do

  before(:all) do
    @tree = FaithAndFarming::Book.family_tree(last_page: 99)
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

    subject(:henry) { tree.individuals.get(name: "Henry /WILLIAMS/") }

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

    subject(:marianne) { tree.individuals.get(name: "Marianne /COLDHAM/") }

    born "12.12.1793"
    died "16.12.1879"

    it "was married to Henry" do
      husband = marianne.families.first.husband
      expect(husband.name).to eq("Henry /WILLIAMS/")
    end

  end

  describe "Edward Marsh Williams" do

    subject(:edward) { tree.individuals.get(name: "Edward Marsh /WILLIAMS/") }

    born "02.11.1818"
    died "11.10.1909"

    it "only appears once" do
      matches = tree.individuals.with(name: edward.name, date_of_birth: edward.date_of_birth)
      pending
      expect(matches.size).to eq(1)
    end

    it "was married to Jane Davis" do
      expect(edward.families.first.wife.name).to eq("Jane /DAVIS/")
    end

    it "had 14 children" do
      pending
      kids_names = edward.families.first.children.map { |i| i.name.split(" ").first }
      expect(kids_names.size).to eq(14)
      expect(kids_names).to include %w[
        Henry
        Samuel
        Mary
        Norman
        Gertrude
        Ada
      ]
    end

  end

end
