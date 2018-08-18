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

    subject(:henry) { tree.find!("Henry /WILLIAMS/") }

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

    subject(:marianne) { tree.find!("Marianne /COLDHAM/") }

    born "12.12.1793"
    died "16.12.1879"

    it "was married to Henry" do
      husband = marianne.families.first.husband
      expect(husband.name).to eq("Henry /WILLIAMS/")
    end

  end

end
