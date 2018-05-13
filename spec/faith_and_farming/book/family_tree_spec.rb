require "spec_helper"

require "faith_and_farming/book"

describe FaithAndFarming::Book, "family tree" do

  before(:all) do
    @tree = FaithAndFarming::Book.family_tree
  end

  attr_reader :tree

  it "has an entry for Henry Williams" do
    pending
    henry = tree.find("Williams, Henry")
    expect(henry).not_to be_nil
    expect(henry.name).to eq("Henry /Williams/")
  end

  # it "has an entry for Marianne Coldham"

end
