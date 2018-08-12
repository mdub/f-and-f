require "spec_helper"

require "familial/dataset"

describe Familial::Family do

  let(:dataset) { Familial::Dataset.new }
  subject(:family) { dataset.families.create }

  it "has a husband and wife" do
    bob = dataset.individuals.create(name: "Bob")
    jane = dataset.individuals.create(name: "Jane")
    family.husband = bob
    family.wife = jane
    expect(family.husband).to eq(bob)
    expect(family.wife).to eq(jane)
  end

  it "has children" do
    family.children << dataset.individuals.create(name: "Becky")
    family.children << dataset.individuals.create(name: "George")
    expect(family.children.map(&:name)).to include("Becky", "George")
  end

end
