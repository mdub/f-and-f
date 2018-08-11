require "spec_helper"

require "faith_and_farming/book"

describe FaithAndFarming::Book, "family tree" do

  before(:all) do
    @tree = FaithAndFarming::Book.family_tree
  end

  attr_reader :tree

  describe "entry for Henry Williams" do

    let(:henry) { tree.find("Williams, Henry") }

    it "exists" do
      expect(henry).not_to be_nil
    end

    it "has the correct #name" do
      expect(henry.name).to eq("Williams, Henry")
    end

    it "has the correct #date_of_birth" do
      expect(henry.date_of_birth.to_s).to eq("11.02.1792")
    end

    it "has the correct #date_of_death" do
      expect(henry.date_of_death.to_s).to eq("16.07.1867")
    end

  end

  describe "entry for Marianne Coldham" do

    let(:marianne) { tree.find("Coldham, Marianne") }

    it "exists" do
      expect(marianne).not_to be_nil
    end

    it "has the correct #name" do
      expect(marianne.name).to eq("Coldham, Marianne")
    end

    it "has the correct #birth" do
      expect(marianne.date_of_birth.to_s).to eq("12.12.1793")
    end

    it "has the correct #date_of_death" do
      expect(marianne.date_of_death.to_s).to eq("16.12.1879")
    end

  end

end
